//
//  TorrentMoveController.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 22.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CoreService.h"

@interface TorrentMoveController : NSWindowController

@property (readonly) CoreService *coreService;
@property (readonly) Torrent *torrent;
@property NSString *downloadDirectory;

-(id)initWithSevice:(CoreService *)service andTorrent:(Torrent *)torrent;
- (IBAction)cancelAction:(id)sender;
- (IBAction)changeLocationAction:(id)sender;

@end
