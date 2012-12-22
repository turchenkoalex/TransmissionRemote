//
//  TorrentMoveController.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 22.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "TorrentMoveController.h"

@interface TorrentMoveController ()

@end

@implementation TorrentMoveController

-(id)initWithSevice:(CoreService *)service andTorrent:(Torrent *)torrent {
    self = [self initWithWindowNibName:@"TorrentMove"];
    if (self) {
        _coreService = service;
        _torrent = torrent;
        _downloadDirectory = [torrent downloadDir];
    }
    return self;
}

-(void)closeWindow {
    [self.window orderOut:nil];
    [NSApp endSheet:self.window];
}

- (IBAction)cancelAction:(id)sender {
    [self closeWindow];
}

- (IBAction)changeLocationAction:(id)sender {
    [_coreService.rpcAssistant torrents:@[_torrent] setLocation:_downloadDirectory andMove:YES];
    [self closeWindow];
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
