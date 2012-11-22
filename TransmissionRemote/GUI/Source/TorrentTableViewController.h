//
//  TorrentTableViewController.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 19.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TorrentTableViewController : NSObject

@property (strong) NSMutableArray *torrentsArray;
@property (weak) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSSegmentedControl *torrentStatusSegmentedControl;
@property (weak) IBOutlet NSSearchField *torrentNameSearchField;

- (IBAction)startTorrentsAction:(id)sender;
- (IBAction)stopTorrentsAction:(id)sender;
- (IBAction)verifyTorrentsAction:(id)sender;
- (IBAction)deleteTorrentsAction:(id)sender;
- (IBAction)filterTorrentAction:(id)sender;

@end
