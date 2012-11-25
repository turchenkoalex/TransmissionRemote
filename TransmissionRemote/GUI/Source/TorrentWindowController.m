//
//  TorrentWindowController.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 24.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "TorrentWindowController.h"
#import "TorrentItem.h"

@interface TorrentWindowController ()

@end

@implementation TorrentWindowController

-(id)initWithTorrent:(Torrent *)torrent {
    self = [super initWithWindowNibName:@"TorrentWindow"];
    if (self) {
        _torrent = torrent;
    }
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
