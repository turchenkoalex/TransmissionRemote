//
//  AppDelegate.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 15.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "AppDelegate.h"
#import "Torrent.h"

@implementation AppDelegate

-(id)init {
    self = [super init];
    if (self) {
        activeRequestInterval = [NSNumber numberWithDouble:1.0];
        unactiveRequestInterval = [NSNumber numberWithDouble:5.0];
        filesQueue = [NSMutableArray array];
        _service = [[Service alloc] initWithDefaults];
        self.serverStatus = [[ServerStatus alloc] init];
    }
    return self;
}

#pragma mark - Loading

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    [self registerNotifications];
    [self.service connectWithDefaultConnectOptions];
}

-(void)dealloc {
    [self unRegisterNotifications];
}


-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (!flag) {
        [[self window] makeKeyAndOrderFront:nil];
    }
    return YES;
}


-(void)applicationWillBecomeActive:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateRequestInterval" object:activeRequestInterval];
}

-(void)applicationWillResignActive:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateRequestInterval" object:unactiveRequestInterval];
}

#pragma mark - Additions Windows

-(IBAction)showOptionsWindow:(id)sender {
    if (!self.optionsWindowController) {
        self.optionsWindowController = [[OptionsWindowController alloc] initWithService:self.service];
    }
    [self.optionsWindowController showWindow:self.window];
}

#pragma mark - Interface Actions

- (IBAction)reconnectAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectRequest" object:nil];
}

- (IBAction)alternativeSpeedAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionSetRequest" object:self.serverStatus];
}

#pragma mark - Notifications

-(void)registerNotifications {
    [self unRegisterNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateServerStatusResponse:) name:@"UpdateServerStatusResponse" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(torrentDownloadedNotification:) name:@"TorrentDownloaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(torrentVerifiedNotification:) name:@"TorrentVerified" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processFilesQueue) name:@"ProcessFilesQueue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertWithNotification:) name:@"ShowMainWindowAlert" object:nil];
}

-(void)unRegisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateServerStatusResponse" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TorrentDownloaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TorrentVerified" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ProcessFilesQueue" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowMainWindowAlert" object:nil];
}

-(void)updateServerStatusResponse:(NSNotification *)notification {
    ServerStatus *object = [notification object];
    if (object) {
        @synchronized(self) {
            self.serverStatus = object;
            if (self.serverStatus.connected) {
                [self processFilesQueue];
            }
        }
    }
}

-(void)torrentDownloadedNotification:(NSNotification *)notification {
    Torrent *torrent = [notification object];
    if (torrent) {
        [self postUserNotificationWithTitle:@"Downloaded" andMessage:[torrent torrentName] andValue:[NSNumber numberWithUnsignedInteger:torrent.torrentId]];
    }
}

-(void)torrentVerifiedNotification:(NSNotification *)notification {
    Torrent *torrent = [notification object];
    if (torrent) {
        [self postUserNotificationWithTitle:@"Verified" andMessage:[torrent torrentName] andValue:[NSNumber numberWithUnsignedInteger:torrent.torrentId]];
    }
}

#pragma mark - NSUserNotifications

-(void)postUserNotificationWithTitle:(NSString *)aTitle andMessage:(NSString *)aMessage andValue:(id)value {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Transmission Remote";
    notification.subtitle = aTitle;
    notification.informativeText = aMessage;
    notification.soundName = NSUserNotificationDefaultSoundName;
    notification.userInfo = @{ @"torrentId": value };
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

-(void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification{
    NSNumber *torrentId = [[notification userInfo] valueForKey:@"torrentId"];
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeDeliveredNotification:notification];
    if (torrentId) {
        [[self window] makeKeyAndOrderFront:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectTorrentById" object:torrentId];
    }
}

#pragma mark - Files processing

-(BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    [filesQueue enqueue:filename];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProcessFilesQueue" object:nil];
    return YES;
}

-(void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
    [filesQueue addObjectsFromArray:filenames];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProcessFilesQueue" object:nil];
}

-(void)processFilesQueue {
    NSString *filename;
    while ((filename = [filesQueue dequeue])) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddTorrentFileRequest" object:filename];
    }
}

#pragma mark - Alerts

-(void)showAlertWithNotification:(NSNotification *)notification {
    NSDictionary *alertInfo = [notification object];
    if (alertInfo) {
        NSAlert *alert = [alertInfo valueForKey:@"alert"];
        void* callback = (__bridge void *) [alertInfo valueForKey:@"callback"];
        if (callback) {
            [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:callback];
        } else {
            [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
        }
    }
}

- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    ((__bridge void(^)(NSInteger result))contextInfo)(returnCode);
    Block_release(contextInfo);
}

@end
