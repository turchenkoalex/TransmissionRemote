//
//  TorrentWindowController.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 24.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Torrent+Viewable.h"

@interface TorrentWindowController : NSWindowController

@property (readonly) Torrent *torrent;

-(id)initWithTorrent:(Torrent *)torrent;

@end
