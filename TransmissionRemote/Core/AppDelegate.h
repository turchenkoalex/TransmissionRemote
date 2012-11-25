//
//  AppDelegate.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 15.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OptionsWindowController.h"
#import "Service.h"
#import "ServerStatus.h"
#import "NSMutableArray+QueueAdditions.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate> {
    NSNumber *activeRequestInterval;
    NSNumber *unactiveRequestInterval;
    NSMutableArray *filesQueue;
}

@property (readonly) Service *service;
@property (assign) IBOutlet NSWindow *window;
@property OptionsWindowController *optionsWindowController;
@property ServerStatus *serverStatus;

- (IBAction)showOptionsWindow:(id)sender;
- (IBAction)reconnectAction:(id)sender;
- (IBAction)alternativeSpeedAction:(id)sender;

@end
