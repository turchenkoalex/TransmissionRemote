//
//  AppDelegate.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CoreService.h"

typedef NS_ENUM(NSUInteger, TorrentStatusFilter) {
    FILTER_STATUS_ALL = 0,
    FILTER_STATUS_ACTIVE = 1,
    FILTER_STATUS_DOWNLOAD = 2,
    FILTER_STATUS_UPLOAD = 3,
    FILTER_STATUS_UNACTIVE = 4
};

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate> {
    IBOutlet NSTableView *_torrentsTableView;
    NSMutableArray *_torrentWindows;
    IBOutlet CoreService *_coreService;
    NSWindowController *_preferencesWindowController;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSArrayController *torrentsArrayController;
@property TorrentStatusFilter torrentStatusFilter;
@property NSString *torrentNameFilter;
@property (nonatomic, readonly) NSWindowController *preferencesWindowController;

- (IBAction)showPreferencesWindow:(id)sender;
- (IBAction)stopTorrentAction:(id)sender;
- (IBAction)startTorrentAction:(id)sender;
- (IBAction)startNowTorrentAction:(id)sender;
- (IBAction)checkTorrentAction:(id)sender;
- (IBAction)removeTorrentAction:(id)sender;
- (IBAction)openTorrentFilesAction:(id)sender;

@end
