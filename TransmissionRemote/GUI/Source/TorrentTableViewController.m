//
//  TorrentTableViewController.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 19.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "TorrentTableViewController.h"
#import "Torrent+Viewable.h"
#import "TorrentWindowController.h"

@implementation TorrentTableViewController

-(id)init {
    self = [super init];
    if (self) {
        self.torrentsArray = [NSMutableArray array];
        torrentWindows = [NSMutableDictionary dictionary];
        self.sortingType = 0;
        [self registerNotifications];
    }
    return self;
}

-(void)awakeFromNib {
    [_tableView setTarget:self];
    [_tableView setDoubleAction:@selector(tableViewDoubleClick:)];
}

-(void)dealloc {
    [self unRegisterNotifications];
}

-(void)updateFilterPredicateWithSearch:(NSString *)searchName andGroup:(NSInteger)stateGroup {
    NSString *nameFilter = nil;
    if([searchName length] > 0) {
        nameFilter = [NSString stringWithFormat:@"torrentName contains[c] '%@'", searchName];
    }
    NSString *stateFilter = nil;
    switch (stateGroup) {
        case 1:
            stateFilter = @"isDownloading == YES";
            break;
        case 2:
            stateFilter = @"isSeeding == YES";
            break;
        case 3:
            stateFilter = @"isWaiting == YES";
            break;
        case 4:
            stateFilter = @"isStopping == YES";
            break;
        default:
            break;
    }
    NSString *filter = nil;
    if (nameFilter) {
        if (stateFilter) {
            filter = [NSString stringWithFormat:@"%@ AND %@", stateFilter, nameFilter];
        } else {
            filter = [nameFilter copy];
        }
    } else {
        if (stateFilter) {
            filter = [stateFilter copy];
        }
    }
    
    if (filter) {
        _arrayController.filterPredicate = [NSPredicate predicateWithFormat:filter];
    } else {
        _arrayController.filterPredicate = nil;
    }
}

-(NSUInteger)sortingType {
    return _sortingType;
}

-(void)setSortingType:(NSUInteger)sortingType {
    _sortingType = sortingType;
    NSArray *sortingDescriptors = nil;
    switch (sortingType) {
        case 0:
            sortingDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"torrentName" ascending:YES]];
            break;

        case 1:
            sortingDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uploadRatio" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"torrentName" ascending:YES]];
            break;

        case 2:
            sortingDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"torrentDownloadPercent" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"torrentName" ascending:YES]];
            break;

        default:
            break;
    }
    if (sortingDescriptors) {
        self.torrentsSortDescriptor = sortingDescriptors;
    }
}

#pragma mark - Notifications

-(void)registerNotifications {
    [self unRegisterNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initializeTorrentsResponse:) name:@"InitializeTorrentsResponse" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTorrentsResponse:) name:@"UpdateTorrentsResponse" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullUpdateTorrentsResponse:) name:@"FullUpdateTorrentsResponse" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTorrentById:) name:@"SelectTorrentById" object:nil];
}

-(void)unRegisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)selectTorrentById:(NSNotification *)notification {
    NSNumber *torrentIdObject = [notification object];
    if (torrentIdObject) {
        NSUInteger torrentId = [torrentIdObject unsignedIntegerValue];
        NSUInteger findedIndex = [[_arrayController arrangedObjects] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if (obj && ((Torrent*)obj).torrentId == torrentId) {
                *stop = YES;
                return YES;
            } else {
                return NO;
            }
        }];
        if (findedIndex != NSNotFound) {
            _arrayController.selectionIndex = findedIndex;
        }
    }
}

-(void)initializeTorrentsResponse:(NSNotification *)notification {
    NSMutableArray *torrents = [notification object];
    if (torrents) {
        @synchronized(_arrayController) {
            [_torrentsArray removeAllObjects];
            [_torrentsArray addObjectsFromArray:torrents];
            [_arrayController rearrangeObjects];
        }
    }
}

-(void)updateTorrentsResponse:(NSNotification *)notification {
    NSMutableArray *torrents = [notification object];
    if (torrents) {
        NSMutableArray *newTorrents = [NSMutableArray array];
        NSMutableArray *removedTorrents = [_torrentsArray mutableCopy];
        @synchronized(_arrayController) {
            BOOL needRearrange = NO;
            for (Torrent *update in torrents) {
                NSUInteger findedIndex = [_torrentsArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    if (obj && ((Torrent*)obj).torrentId == update.torrentId) {
                        *stop = YES;
                        return YES;
                    } else {
                        return NO;
                    }
                }];
                if (findedIndex != NSNotFound) {
                    Torrent *torrent = [_torrentsArray objectAtIndex:findedIndex];
                    if (torrent) {
                        if (torrent.torrentState != update.torrentState) {
                            torrent.torrentState = update.torrentState;
                            needRearrange = YES;
                        }
                        if (torrent.torrentDownloadPercent != update.torrentDownloadPercent) {
                            if (update.torrentDownloadPercent == 100) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentDownloaded" object:torrent];
                            }
                            torrent.torrentDownloadPercent = update.torrentDownloadPercent;
                            if (self.sortingType == 2) {
                                needRearrange = YES;
                            }
                        }
                        if (torrent.torrentVerifyPercent != update.torrentVerifyPercent) {
                            if (torrent.torrentVerifyPercent > 0 && update.torrentVerifyPercent == 0 && torrent.uploadRatio != -1) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentVerified" object:torrent];
                            }
                            torrent.torrentVerifyPercent = update.torrentVerifyPercent;
                        }
                        if (torrent.uploadRatio != update.uploadRatio) {
                            torrent.uploadRatio = update.uploadRatio;
                            if (self.sortingType == 1) {
                                needRearrange = YES;
                            }
                        }
                        [removedTorrents removeObject:torrent];
                    }
                } else {
                    [newTorrents addObject:update];
                }
            }
            if (needRearrange) {
                [_arrayController rearrangeObjects];
            }
        }
        if ([newTorrents count] > 0) {
            NSString *ids = [[newTorrents valueForKeyPath:@"torrentId"] componentsJoinedByString:@","];
            [self fullUpdateTorrentsRequestWithIds:ids];
        }
        if([removedTorrents count] > 0) {
            [self removeTorrentWindows:removedTorrents];
            [_arrayController removeObjects:removedTorrents];
        }
    }
}

-(void)fullUpdateTorrentsResponse:(NSNotification *)notification {
    NSMutableArray *torrents = [notification object];
    if (torrents) {
        @synchronized(_arrayController) {
            NSArray *newTorrents = [torrents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (torrentId IN %@)", [_torrentsArray valueForKeyPath:@"torrentId"]]];
            if ([newTorrents count] > 0) {
                [_torrentsArray addObjectsFromArray:newTorrents];
                [_arrayController rearrangeObjects];
                [_arrayController setSelectedObjects:newTorrents];
                for(Torrent *torrent in newTorrents) {
                    [self showTorrent:torrent];
                }
            }
        }
    }
}

#pragma mark - Requests

-(void)fullUpdateTorrentsRequestWithIds:(NSString *)aIds {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FullUpdateTorrentsRequest" object:aIds];
}

-(void)torrentsStopRequestWithIds:(NSString *)aIds {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentsStopRequest" object:aIds];
}

-(void)torrentsStartRequestWithIds:(NSString *)aIds {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentsStartRequest" object:aIds];
}

-(void)torrentsStartNowRequestWithIds:(NSString *)aIds {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentsStartNowRequest" object:aIds];
}

-(void)torrentsVerifyRequestWithIds:(NSString *)aIds {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentsVerifyRequest" object:aIds];
}

-(void)torrentsRemoveRequestWithIds:(NSString *)aIds {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TorrentsRemoveRequest" object:aIds];
}

#pragma mark - IBActions

-(NSArray *)selectedTorrens {
    NSInteger row = [_tableView clickedRow];
    if (row != -1) {
        Torrent *clickedTorrent = [[_arrayController arrangedObjects] objectAtIndex:row];
        NSArray *selectedTorrents = [_arrayController selectedObjects];
        if ([selectedTorrents containsObject:clickedTorrent]) {
            return selectedTorrents;
        } else {
            return @[clickedTorrent];
        }
    } else {
        return [_arrayController selectedObjects];
    }
}

- (IBAction)startTorrentsAction:(id)sender {
    NSArray *selected = [self selectedTorrens];
    if ([selected count] > 0) {
        NSString * ids = [[selected valueForKeyPath:@"torrentId"] componentsJoinedByString:@","];
        [self torrentsStartRequestWithIds:ids];
    }
}

- (IBAction)startNowTorrentsAction:(id)sender {
    NSArray *selected = [self selectedTorrens];
    if ([selected count] > 0) {
        NSString * ids = [[selected valueForKeyPath:@"torrentId"] componentsJoinedByString:@","];
        [self torrentsStartRequestWithIds:ids];
    }
}

- (IBAction)stopTorrentsAction:(id)sender {
    NSArray *selected = [self selectedTorrens];
    if ([selected count] > 0) {
        NSString * ids = [[selected valueForKeyPath:@"torrentId"] componentsJoinedByString:@","];
        [self torrentsStopRequestWithIds:ids];
    }
}

- (IBAction)verifyTorrentsAction:(id)sender {
    NSArray *selected = [self selectedTorrens];
    if ([selected count] > 0) {
        NSString * ids = [[selected valueForKeyPath:@"torrentId"] componentsJoinedByString:@","];
        [self torrentsVerifyRequestWithIds:ids];
    }
}

- (IBAction)removeWithDataTorrentsAction:(id)sender {
    NSArray *selected = [self selectedTorrens];
    if ([selected count] > 0) {
        NSString *names = [[selected valueForKeyPath:@"torrentName"] componentsJoinedByString:@", "];
        NSString * ids = [[selected valueForKeyPath:@"torrentId"] componentsJoinedByString:@","];
        NSAlert *alert = [NSAlert alertWithMessageText:@"Are you shure?" defaultButton:@"Remove" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Removing torrents: %@", names];
        
        void (^blockCallback)(NSInteger) = ^(NSInteger returnCode) {
            if (returnCode == NSAlertDefaultReturn) {
                [self torrentsRemoveRequestWithIds:ids];
            }
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMainWindowAlert" object:@{ @"alert": alert, @"callback": (__bridge id) Block_copy((__bridge void *)blockCallback) }];
    }
}

- (IBAction)filterTorrentsAction:(id)sender {
    NSInteger stateGroup = [self.torrentStatusSegmentedControl selectedSegment];
    NSString *searchString = [self.torrentNameSearchField stringValue];
    [self updateFilterPredicateWithSearch:searchString andGroup:stateGroup];
}

- (IBAction)sortingTorrentsAction:(id)sender {
    NSMenuItem *item = sender;
    if (item) {
        self.menuSortByName.state = 0;
        self.menuSortByRatio.state = 0;
        self.menuSortBySize.state = 0;
        item.state = 1;
        self.sortingType = [item tag];
    }
}

-(void)removeTorrentWindows:(NSArray *)torrents {
    for(Torrent *torrent in torrents) {
        if (torrent) {
            [torrentWindows removeObjectForKey:torrent.torrentIdString];
        }
    }
}

-(void)showTorrent:(Torrent *)torrent {
    if (torrent) {
        TorrentWindowController *controller = [torrentWindows valueForKey:torrent.torrentIdString];
        if (!controller) {
            controller = [[TorrentWindowController alloc] initWithTorrent:torrent];
            [torrentWindows setValue:controller forKey:torrent.torrentIdString];
        }
        [controller showWindow:self];
    }
}

-(void)tableViewDoubleClick:(id)object {
    NSInteger row = [_tableView clickedRow];
    if (row != -1) {
        [self showTorrent:[[_arrayController arrangedObjects] objectAtIndex:row]];
    }
}

@end
