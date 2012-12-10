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
#import "TorrentControllerDelegate.h"

@interface TorrentController : NSWindowController {
    NSArray *_files;
    id <TorrentControllerDelegate> _delegate;
}

-(id)initWithSevice:(CoreService *)service andTorrent:(Torrent *)torrent andDelegate:(id <TorrentControllerDelegate>)delegate;

@property (readonly) CoreService *coreService;
@property (readonly) Torrent *torrent;
@property (readonly) NSArray *filesTree;
@property (weak) IBOutlet NSOutlineView *filesOutlineView;
@property (strong) IBOutlet NSTreeController *filesTreeController;

- (IBAction)applyChanges:(id)sender;
- (IBAction)enableFileAction:(id)sender;
- (IBAction)disableFileAction:(id)sender;

@end