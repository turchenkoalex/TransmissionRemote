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
    }
    return self;
}

#pragma mark - Loading

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.systemService = [[SystemService alloc] initWithDefaults];
    self.serverStatus = [[ServerStatus alloc] init];
        
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    [self registerNotifications];
    [self.systemService connectWithDefaultConnectOptions];
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
        self.optionsWindowController = [[OptionsWindowController alloc] initWithService:self.systemService];
    }
    [self.optionsWindowController showWindow:self.window];
}

#pragma mark - Notifications

-(void)registerNotifications {
    [self unRegisterNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateServerStatusResponse:) name:@"UpdateServerStatusResponse" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(torrentDownloadedNotification:) name:@"TorrentDownloaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(torrentVerifiedNotification:) name:@"TorrentVerified" object:nil];
}

-(void)unRegisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateServerStatusResponse" object:nil];
}

-(void)updateServerStatusResponse:(NSNotification *)notification {
    ServerStatus *object = [notification object];
    if (object) {
        @synchronized(self) {
            self.serverStatus = object;
        }
    }
}

-(void)torrentDownloadedNotification:(NSNotification *)notification {
    Torrent *torrent = [notification object];
    if (torrent) {
        [self postUserNotificationWithTitle:@"Downloaded" andMessage:[torrent torrentName]];
    }
}

-(void)torrentVerifiedNotification:(NSNotification *)notification {
    Torrent *torrent = [notification object];
    if (torrent) {
        [self postUserNotificationWithTitle:@"Verified" andMessage:[torrent torrentName]];
    }
}

#pragma mark - NSUserNotifications

-(void)postUserNotificationWithTitle:(NSString *)aTitle andMessage:(NSString *)aMessage {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Transmission Remote";
    notification.subtitle = aTitle;
    notification.informativeText = aMessage;
    notification.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

-(void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification{
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeDeliveredNotification:notification];
}

@end
