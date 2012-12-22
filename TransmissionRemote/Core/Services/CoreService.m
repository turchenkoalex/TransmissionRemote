//
//  CoreService.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "CoreService.h"

const double RefreshIntervalActive = 3.0;
const double RefreshIntervalUnactive = 6.0;
const double ReconnectIntervalActive = 30.0;
const double ReconnectIntervalUnactive = 60.0;

@implementation CoreService

-(id)init {
    self = [super init];
    if (self) {
        _torrentsAssistant = [[TorrentsServiceAssistant alloc] initWithDelegate:self];
        _rpcAssistant = [[RpcServiceAssistant alloc] initWithDelegate:self andProtocolDelegate:_torrentsAssistant];
        _optionsAssistant = [[OptionsServiceAssistant alloc] init];
        _refreshInterval = [NSNumber numberWithDouble:RefreshIntervalActive];
        _filesQueue = [NSMutableArray array];
        _watingAddTorrents = [NSMutableSet set];
    }
    return self;
}

#pragma mark - Server Connection Logic

-(void)start {
    [self reconnect];
}

-(void)reconnect {
    if (!(_serverStatus && _serverStatus.connected)) {
        [self connect];
        [self performSelector:@selector(reconnect) withObject:nil afterDelay:ReconnectIntervalActive];
    } else {
        [self performSelector:@selector(reconnect) withObject:nil afterDelay:ReconnectIntervalUnactive];
    }
}

-(void)connect {
    [_optionsAssistant loadDefaults];
    if ([_optionsAssistant.connectOptions.server length]) {
        [_optionsAssistant updateCredentials];
        [_rpcAssistant getServerStatus];
    }
}

-(void)disconnect {
    [NSObject cancelPreviousPerformRequestsWithTarget:_rpcAssistant];
    self.serverStatus.connected = NO;
    self.serverStatus.version = @"Disconnected";
    self.rateDownload = 0;
    self.rateUpload = 0;
    [_torrentsAssistant removeAllTorrents];
}

-(void)updateRecentlyChangedTorrents {
    double delay = RefreshIntervalActive;
    @synchronized(_refreshInterval) {
        delay = [_refreshInterval doubleValue];
    }
    [_rpcAssistant performSelector:@selector(updateRecentlyChangedTorrents) withObject:nil afterDelay:delay];
}

-(void)activityUp {
    @synchronized(_refreshInterval) {
        _refreshInterval = [NSNumber numberWithDouble:RefreshIntervalActive];
    }
}

-(void)activityDown {
    @synchronized(_refreshInterval) {
        _refreshInterval = [NSNumber numberWithDouble:RefreshIntervalUnactive];
    }
}

-(void)addTorrentFiles:(NSArray *)filenames {
    @synchronized(_filesQueue) {
        [_filesQueue addObjectsFromArray:filenames];
    }
    [self proceedFilesQueue];
}

-(void)proceedFilesQueue {
    if (_serverStatus && _serverStatus.connected) {
        NSMutableArray *filesData;
        
        @synchronized(_filesQueue) {
            filesData = [NSMutableArray arrayWithCapacity:[_filesQueue count]];
            for (id filename in _filesQueue) {
                @try {
                    NSData *fileData;
                    BOOL isURL = [filename isKindOfClass:[NSURL class]];
                    NSURL *filenameURL;
                    if (!isURL) {
                        filenameURL = [[NSURL alloc] initFileURLWithPath:filename];
                    } else {
                        filenameURL = filename;
                    }
                    fileData = [NSData dataWithContentsOfURL:filenameURL];
                    if (_optionsAssistant.appOptions.removeFilesAfterAddingTorrent) {
                        NSURL *trashedFilename;
                        NSError *error;
                        [[NSFileManager defaultManager] trashItemAtURL:filenameURL resultingItemURL:&trashedFilename error:&error];
                    }
                    if (fileData) {
                        [filesData addObject:fileData];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            }
            [_filesQueue removeAllObjects];
        }
        
        for (NSData *data in filesData) {
            [_rpcAssistant addTorrentWithMetadata:data andStart:_optionsAssistant.appOptions.startTorrentAfterAdding];
        }
    }
}

#pragma mark - <TorrentServiceAssistantDelegate>

-(void)torrentServiceAssistantDidInitializeTorrentsArray {
    [self notifyAboutTorrentsArrayChanging];
    [self updateRecentlyChangedTorrents];
}

-(void)torrentServiceAssistantDidUpdateTorrentsArrayWithChange:(BOOL)changed {
    [self updateRecentlyChangedTorrents];
    if (changed) {
        [self notifyAboutTorrentsArrayChanging];
    }
}

-(void)torrentServiceAssistantDidFindNewTorrentsWithTorrentIdArray:(NSArray *)torrentIdArray {
    [_rpcAssistant loadTorrentsDataForTorrentIdArray:torrentIdArray];
}

-(void)torrentServiceAssistantDidRemoveTorrentsArray:(NSArray *)torrentsArray {
    [self notifyAboutTorrentsArrayChanging];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentsRemoved" object:torrentsArray];
}

-(void)torrentServiceAssistantDidLoadTorrentsArray:(NSArray *)torrentsArray {
    NSMutableArray *showingTorrents = [NSMutableArray arrayWithCapacity:[torrentsArray count]];
    @synchronized(_watingAddTorrents) {
        for (Torrent *torrent in torrentsArray) {
            NSString *torrentId = [NSString stringWithFormat:@"%@", torrent.id];
            if ([_watingAddTorrents containsObject:torrentId]) {
                [showingTorrents addObject:torrent];
                [_watingAddTorrents removeObject:torrentId];
            }
        }
    }
    [self notifyAboutTorrentsArrayChanging];
    if ([showingTorrents count] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentsAdded" object:showingTorrents];
    }
}

-(void)torrentServiceAssistantDidUpdateServerStatus:(ServerStatus *)serverStatus {
    BOOL alreadyConnected = [self.serverStatus connected];
    if (self.serverStatus) {
        [self.serverStatus removeObserver:self forKeyPath:@"speedLimit"];
    }
    [self willChangeValueForKey:@"serverStatus"];
    _serverStatus = serverStatus;
    [self didChangeValueForKey:@"serverStatus"];
    if (self.serverStatus) {
        [self.serverStatus addObserver:self forKeyPath:@"speedLimit" options:NSKeyValueObservingOptionNew context:nil];
        if (!alreadyConnected && [self.serverStatus connected]) {
            [_rpcAssistant initializeTorrents];
        }
    }
    [self proceedFilesQueue];
}

-(void)torrentServiceAssistantDidCheckedTorrents:(NSArray *)torrentsArray {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentsChecked" object:torrentsArray];
}

-(void)torrentServiceAssistantDidDownloadedTorrents:(NSArray *)torrentsArray {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentsDownloaded" object:torrentsArray];
}

-(void)torrentServiceAssistantDidChangeTotalDownloadRate:(NSUInteger)downloadRate andUploadRate:(NSUInteger)uploadRate {
    self.rateDownload = downloadRate;
    self.rateUpload = uploadRate;
}

-(void)torrentServiceAssistantDidChangeTorrent:(NSString *)torrentId {
    [_rpcAssistant updateTorrentsDataForTorrentIdArray:@[torrentId]];
}

-(void)torrentServiceAssistantDidAddTorrent:(id)torrentId {
    @synchronized(_watingAddTorrents) {
        [_watingAddTorrents addObject:[NSString stringWithFormat:@"%@", torrentId]];
    }
}

-(void)torrentServiceAssistantDidChangeTorrents:(NSArray *)torrentIdArray {
    [_rpcAssistant loadTorrentsDataForTorrentIdArray:torrentIdArray];
}

#pragma mark - <RpcServiceAssistantDelegate>

-(NSURL *)rpcServiceURL {
    return [_optionsAssistant.connectOptions rpcServerURL];
}

#pragma mark - Notifications

-(void)notifyAboutTorrentsArrayChanging {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentsArrayChanged" object:nil];
}

#pragma mark - Observing

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([object isEqual:self.serverStatus] && [keyPath isEqual:@"speedLimit"]) {
        [_rpcAssistant setServerStatus:self.serverStatus];
    }
}

@end
