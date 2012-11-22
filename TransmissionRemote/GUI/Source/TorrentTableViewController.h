//
//  TorrentTableViewController.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 19.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TorrentTableViewController : NSObject {
    NSUInteger _sortingType;
}

@property (strong) NSMutableArray *torrentsArray;
@property (strong) NSArray *torrentsSortDescriptor;
@property NSUInteger sortingType;
@property (weak) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSSegmentedControl *torrentStatusSegmentedControl;
@property (weak) IBOutlet NSSearchField *torrentNameSearchField;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSMenuItem *menuSortByName;
@property (weak) IBOutlet NSMenuItem *menuSortByRatio;
@property (weak) IBOutlet NSMenuItem *menuSortBySize;

- (IBAction)startTorrentsAction:(id)sender;
- (IBAction)stopTorrentsAction:(id)sender;
- (IBAction)verifyTorrentsAction:(id)sender;
- (IBAction)deleteTorrentsAction:(id)sender;
- (IBAction)filterTorrentsAction:(id)sender;
- (IBAction)sortingTorrentsAction:(id)sender;

@end
