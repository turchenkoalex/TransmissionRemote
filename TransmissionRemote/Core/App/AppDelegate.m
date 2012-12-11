//
//  AppDelegate.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "AppDelegate.h"
#import "RpcProtocol.h"
#import "Torrent+Statusing.h"
#import "TorrentController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _torrentWindows = [NSMutableArray array];
    [self startNotificationsObserving];
    self.torrentStatusFilter = FILTER_STATUS_ALL;
    [self addObserver:self forKeyPath:@"torrentStatusFilter" options:0 context:nil];
    [self addObserver:self forKeyPath:@"torrentNameFilter" options:0 context:nil];

    [_coreService start];
    
    if (!_coreService.optionsAssistant.connectOptions.server) {
        [self showOptionsWindow:self];
    }
}

-(void)awakeFromNib {
    [_torrentsTableView setTarget:self];
    [_torrentsTableView setDoubleAction:@selector(torrentsTableViewDoubleClick:)];
}

-(void)applicationWillBecomeActive:(NSNotification *)notification {
    [_coreService activityUp];
}

-(void)applicationWillResignActive:(NSNotification *)notification {
    [_coreService activityDown];
}

-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (!flag) {
        [[self window] makeKeyAndOrderFront:nil];
    }
    return YES;
}

-(void)dealloc {
    [self stopNotificationsObserving];
}

#pragma mark - Filtering

-(void)applyFilters {
    NSString *predicateString;
    TorrentChangeObservingMask torrentChangeObservingMask = TorrentChangeObservingStatusMask;
    switch (self.torrentStatusFilter) {
        case FILTER_STATUS_ACTIVE:
            predicateString = [NSString stringWithFormat:@"(torrentStatus == %ld || torrentStatus == %ld)", STATUS_DOWNLOAD, STATUS_SEED];
            break;
        case FILTER_STATUS_UNACTIVE:
            predicateString = [NSString stringWithFormat:@"torrentStatus == %ld || torrentStatus == %ld ", STATUS_UNACTIVE, STATUS_VERIFY];
            break;
        case FILTER_STATUS_DOWNLOAD:
            predicateString = [NSString stringWithFormat:@"torrentStatus == %ld", STATUS_DOWNLOAD];
            break;
        case FILTER_STATUS_UPLOAD:
            predicateString = [NSString stringWithFormat:@"torrentStatus == %ld", STATUS_SEED];
            break;
        default:
            predicateString = nil;
            torrentChangeObservingMask = TorrentChangeObservingNoneMask;
            break;
    }
    if ([self.torrentNameFilter length] > 0) {
        if (predicateString) {
            predicateString = [NSString stringWithFormat:@"%@ AND name contains[c] '%@'", predicateString, self.torrentNameFilter];
        } else {
            predicateString = [NSString stringWithFormat:@"name contains[c] '%@'", self.torrentNameFilter];
        }
    }
    if (predicateString) {
        [self.torrentsArrayController setFilterPredicate:[NSPredicate predicateWithFormat:predicateString]];
    } else {
        [self.torrentsArrayController setFilterPredicate:nil];
    }
    _coreService.torrentsAssistant.torrentChangeObservingMask = torrentChangeObservingMask;
}

#pragma mark - Observing

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqual:@"torrentStatusFilter"] || [keyPath isEqual:@"torrentNameFilter"]) {
        [self applyFilters];
    }
}

-(void)startNotificationsObserving {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceDidChangedTorrentsArrayNotification:) name:@"TorrentsArrayChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceDidDownloadedTorrentsNotification:) name:@"TorrentsDownloaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceDidCheckedTorrentsNotification:) name:@"TorrentsChecked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceDidAddedTorrentsNotification:) name:@"TorrentsAdded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceDidRemovedTorrentsNotification:) name:@"TorrentsRemoved" object:nil];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

-(void)stopNotificationsObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TorrentsArrayChanged" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TorrentsDownloaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TorrentsChecked" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TorrentsAdded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TorrentsRemoved" object:nil];
}

-(void)serviceDidChangedTorrentsArrayNotification:(NSNotification *)notification {
    @synchronized(_torrentsArrayController) {
        [_torrentsArrayController rearrangeObjects];
    }
}

-(void)serviceDidDownloadedTorrentsNotification:(NSNotification *)notification {
    NSArray *torrents = [notification object];
    for (Torrent *torrent in torrents) {
        [self postUserNotificationWithTitle:@"Download complete" andMessage:torrent.name andValue:torrent.id];
    }
}

-(void)serviceDidCheckedTorrentsNotification:(NSNotification *)notification {
    NSArray *torrents = [notification object];
    for (Torrent *torrent in torrents) {
        [self postUserNotificationWithTitle:@"Verify complete" andMessage:torrent.name andValue:torrent.id];
    }
}

-(void)serviceDidAddedTorrentsNotification:(NSNotification *)notification {
    NSArray *torrents = [notification object];
    for (Torrent *torrent in torrents) {
        [self showWindowForTorrent:torrent];
    }
}

-(void)serviceDidRemovedTorrentsNotification:(NSNotification *)notification {
    NSArray *torrents = [notification object];
    for (Torrent *torrent in torrents) {
    }
}

#pragma mark - IB Actions

-(NSArray *)selectedTorrens {
    NSInteger row = [_torrentsTableView clickedRow];
    if (row != -1 && ![_torrentsTableView isRowSelected:row]) {
        return @[[[_torrentsArrayController arrangedObjects] objectAtIndex:row]];
    } else {
        return [_torrentsArrayController selectedObjects];
    }
}

-(void)torrentsTableViewDoubleClick:(id)object {
    NSInteger row = [_torrentsTableView clickedRow];
    if (row != -1) {
        [self showWindowForTorrent:[[_torrentsArrayController arrangedObjects] objectAtIndex:row]];
    }
}

-(void)showWindowForTorrent:(Torrent *)torrent {
    if (torrent) {
        TorrentController *controller = [[TorrentController alloc] initWithSevice:_coreService andTorrent:torrent];
        [_torrentWindows addObject:controller];
        [NSApp beginSheet:controller.window modalForWindow:self.window modalDelegate:self didEndSelector:@selector(torrentWindowDidEnd:returnCode:contextInfo:) contextInfo:(__bridge void*)controller];
    }
}

-(void)torrentWindowDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    id controller = (__bridge id)contextInfo;
    [_torrentWindows removeObject:controller];
}

-(IBAction)showOptionsWindow:(id)sender {
    if (!_optionsController) {
        _optionsController = [[OptionsController alloc] initWithService:_coreService];
    }
    [_optionsController showWindow:self];
}

- (IBAction)stopTorrentAction:(id)sender {
    NSArray *selectedTorrents = [self selectedTorrens];
    if ([selectedTorrents count] > 0) {
        [_coreService.rpcAssistant stopTorrentsArray:selectedTorrents];
    }
}

- (IBAction)startTorrentAction:(id)sender {
    NSArray *selectedTorrents = [self selectedTorrens];
    if ([selectedTorrents count] > 0) {
        [_coreService.rpcAssistant startTorrentsArray:selectedTorrents rightNow:NO];
    }
}

- (IBAction)startNowTorrentAction:(id)sender {
    NSArray *selectedTorrents = [self selectedTorrens];
    if ([selectedTorrents count] > 0) {
        [_coreService.rpcAssistant startTorrentsArray:selectedTorrents rightNow:YES];
    }
}

- (IBAction)checkTorrentAction:(id)sender {
    NSArray *selectedTorrents = [self selectedTorrens];
    if ([selectedTorrents count] > 0) {
        [_coreService.rpcAssistant recheckTorrentsArray:selectedTorrents];
    }
}

- (IBAction)removeTorrentAction:(id)sender {
    NSArray *selectedTorrents = [self selectedTorrens];
    if ([selectedTorrents count] > 0) {
        NSString *names = [[selectedTorrents valueForKeyPath:@"name"] componentsJoinedByString:@", "];
        NSAlert *alert = [NSAlert alertWithMessageText:@"Are you shure?" defaultButton:@"Remove" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Removing torrents: %@", names];
        void (^blockCallback)(NSInteger) = ^(NSInteger returnCode) {
            if (returnCode == NSAlertDefaultReturn) {
                [_coreService.rpcAssistant removeTorrentsArray:selectedTorrents withLocalData:_coreService.optionsAssistant.appOptions.removeTorrentWithLocalData];
            }
        };
        [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:Block_copy((__bridge void *)blockCallback)];
    }
}

- (IBAction)openTorrentFilesAction:(id)sender {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            [_coreService addTorrentFiles:[panel URLs]];
        }
    }];
}

#pragma mark - <NSUserNotificationCenterDelegate>

-(void)postUserNotificationWithTitle:(NSString *)aTitle andMessage:(NSString *)aMessage andValue:(id)value {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Transmission Remote";
    notification.subtitle = aTitle;
    notification.informativeText = aMessage;
    notification.soundName = NSUserNotificationDefaultSoundName;
    notification.userInfo = @{ @"value": value };
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

-(void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification{
    id value = [[notification userInfo] valueForKey:@"value"];
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeDeliveredNotification:notification];
    if (value) {
        [[self window] makeKeyAndOrderFront:nil];
    }
}

#pragma mark - NSAlert

- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    ((__bridge void(^)(NSInteger result))contextInfo)(returnCode);
    Block_release(contextInfo);
}

#pragma mark - Files

-(BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    [_coreService addTorrentFiles:@[filename]];
    return YES;
}

-(void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
    [_coreService addTorrentFiles:filenames];
}

@end
