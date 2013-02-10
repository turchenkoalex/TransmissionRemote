//
//  TorrentsServiceAssistant.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "TorrentsServiceAssistant.h"
#import "Torrent.h"

@implementation TorrentsServiceAssistant

-(id)init {
    self = [super init];
    if (self) {
        _torrentsArray = [NSMutableArray array];
        _torrentsDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

-(id)initWithDelegate:(id <TorrentServiceAssistantDelegate>)aDelegate {
    self = [self init];
    if (self) {
        _delegate = aDelegate;
    }
    return self;
}

-(void)removeAllTorrents {
    [_torrentsArray removeAllObjects];
    [_torrentsDictionary removeAllObjects];
    if (_delegate) {
        [_delegate torrentServiceAssistantDidUpdateTorrentsArrayWithChange:YES];
    }
}

#pragma mark - <RpcProtocolDelegate>

-(void)rpcProtocolDidReceiveInitializedTorrents:(NSArray *)torrents {
    if (torrents) {
        NSUInteger rateDownload = 0;
        NSUInteger rateUpload = 0;
        @synchronized(_torrentsArray) {
            [_torrentsArray removeAllObjects];
            [_torrentsArray addObjectsFromArray:torrents];
            [_torrentsDictionary removeAllObjects];
            for(Torrent *torrent in torrents) {
                [_torrentsDictionary setValue:torrent forKey:torrent.id];
                rateDownload += torrent.rateDownload;
                rateUpload += torrent.rateUpload;
            }
        }
        if (_delegate) {
            [_delegate torrentServiceAssistantDidInitializeTorrentsArray];
            [_delegate torrentServiceAssistantDidChangeTotalDownloadRate:rateDownload andUploadRate:rateUpload];
        }
    }
}

-(BOOL)torrentWillChangeWhen:(Torrent *)torrent updatedWithTorrent:(Torrent *)updateTorrent {
    return ((_torrentChangeObservingMask & TorrentChangeObservingStatusMask) && (torrent.status != updateTorrent.status));
}

-(void)rpcProtocolDidReceiveUpdatedTorrents:(NSArray *)torrents {
    if (torrents && [torrents count] > 0) {
        NSMutableArray *addedTorrentsIds = [NSMutableArray array];
        NSMutableArray *downloadedTorrents = [NSMutableArray array];
        NSMutableArray *checkedTorrents = [NSMutableArray array];
        NSUInteger rateDownload = 0;
        NSUInteger rateUpload = 0;
        BOOL arrayChanged = NO;
        @synchronized(_torrentsArray) {
            for (Torrent *updateTorrent in torrents) {
                rateDownload += updateTorrent.rateDownload;
                rateUpload += updateTorrent.rateUpload;
                Torrent *torrent = [_torrentsDictionary objectForKey:updateTorrent.id];
                if (torrent) {
                    if (torrent.status == STATE_DOWNLOAD && torrent.percentDone < updateTorrent.percentDone && updateTorrent.percentDone == 1) {
                        [downloadedTorrents addObject:torrent];
                    }
                    if (torrent.status == STATE_CHECK && torrent.recheckProgress > 0 && updateTorrent.recheckProgress == 0 && torrent.uploadRatio != -1) {
                        [checkedTorrents addObject:torrent];
                    }
                    if (!arrayChanged) {
                        arrayChanged = [self torrentWillChangeWhen:torrent updatedWithTorrent:updateTorrent];
                    }
                    [torrent applyChangesFromTorrent:updateTorrent];
                } else {
                    [addedTorrentsIds addObject:updateTorrent.id];
                }
            }
        }
        if (_delegate) {
            [_delegate torrentServiceAssistantDidUpdateTorrentsArrayWithChange:arrayChanged];
            [_delegate torrentServiceAssistantDidChangeTotalDownloadRate:rateDownload andUploadRate:rateUpload];
            if ([addedTorrentsIds count] > 0) {
                [_delegate torrentServiceAssistantDidFindNewTorrentsWithTorrentIdArray:addedTorrentsIds];
            }
            if ([downloadedTorrents count] > 0) {
                [_delegate torrentServiceAssistantDidDownloadedTorrents:downloadedTorrents];
            }
            if ([checkedTorrents count] > 0) {
                [_delegate torrentServiceAssistantDidCheckedTorrents:checkedTorrents];
            }
        }
    }
}

-(void)rpcProtocolDidReceiveRemovedTorrentIdArray:(NSArray *)torrents {
    if (torrents && [torrents count] > 0) {
        @synchronized(_torrentsArray) {
            NSMutableArray *removedArray = [NSMutableArray arrayWithCapacity:[torrents count]];
            for (id torrentId in torrents) {
                Torrent *removingTorrent = [_torrentsDictionary objectForKey:torrentId];
                if (removingTorrent) {
                    [removedArray addObject:removingTorrent];
                }
            }
            if ([removedArray count] > 0) {
                [_torrentsDictionary removeObjectsForKeys:torrents];
                [_torrentsArray removeObjectsInArray:removedArray];
                if (_delegate) {
                    [_delegate torrentServiceAssistantDidRemoveTorrentsArray:removedArray];
                }
            }
        }
    }
}

-(void)rpcProtocolDidReceiveLoadedTorrents:(NSArray *)torrents {
    if (torrents && [torrents count] > 0) {
        NSMutableArray *addedTorrents = [NSMutableArray arrayWithCapacity:[torrents count]];
        @synchronized(_torrentsArray) {
            for(Torrent *torrent in torrents) {
                Torrent *finded = [_torrentsDictionary objectForKey:torrent.id];
                if (finded) {
                    finded.downloadDir = torrent.downloadDir;
                    finded.files = torrent.files;
                    finded.fileStats = torrent.fileStats;
                } else {
                    [_torrentsDictionary setValue:torrent forKey:torrent.id];
                    [addedTorrents addObject:torrent];
                    [_torrentsArray addObject:torrent];
                }
            }
        }
        if (_delegate) {
            [_delegate torrentServiceAssistantDidLoadTorrentsArray:addedTorrents];
        }
    }
}

-(void)rpcProtocolDidReceiveAddedTorrentId:(NSString *)torrentId {
    if (_delegate) {
        [_delegate torrentServiceAssistantDidAddTorrent:torrentId];
    }
}

-(void)rpcProtocolDidReceiveServerStatus:(ServerStatus *)serverStatus {
    if (_delegate) {
        [_delegate torrentServiceAssistantDidUpdateServerStatus:serverStatus];
    }
}

-(void)rpcProtocolDidReceiveChangeOfTorrent:(NSString *)torrentId {
    if (_delegate) {
        [_delegate torrentServiceAssistantDidChangeTorrent:torrentId];
    }
}

-(void)rpcProtocolDidReceiveChangeOfTorrents:(NSArray *)torrentIdArray {
    if (_delegate) {
        [_delegate torrentServiceAssistantDidChangeTorrents:torrentIdArray];
    }
}

@end
