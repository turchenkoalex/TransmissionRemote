//
//  TorrentWindowController.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 24.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Torrent+Viewable.h"
#import "AppOptions.h"

@interface TorrentWindowController : NSWindowController

@property (readonly) Torrent *torrent;
@property (readonly) AppOptions *appOptions;

-(id)initWithTorrent:(Torrent *)torrent andOptions:(AppOptions *)options;

- (IBAction)resumeTorrent:(id)sender;
- (IBAction)stopTorrent:(id)sender;
- (IBAction)removeTorrent:(id)sender;

@end
