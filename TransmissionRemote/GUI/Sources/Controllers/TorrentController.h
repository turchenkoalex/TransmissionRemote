//
//  TorrentController.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 06.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CoreService.h"
#import "Torrent.h"
#import "TorrentMoveController.h"

@interface TorrentController : NSWindowController {
    NSArray *_files;
    TorrentMoveController *_torrentMoveController;
}

-(id)initWithSevice:(CoreService *)service andTorrent:(Torrent *)torrent;

@property (readonly) CoreService *coreService;
@property (readonly, weak) Torrent *torrent;
@property NSArray *filesTree;
@property (weak) IBOutlet NSOutlineView *filesOutlineView;
@property (strong) IBOutlet NSTreeController *filesTreeController;
@property (readonly) TorrentMoveController *torrentMoveController;

- (IBAction)applyChanges:(id)sender;
- (IBAction)enableFileAction:(id)sender;
- (IBAction)disableFileAction:(id)sender;
- (IBAction)changeLocation:(id)sender;
- (void)closeTorrentWindow;

@end
