//
//  TorrentController.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 06.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "TorrentController.h"
#import "TorrentParentedFile.h"

@interface TorrentController ()

@end

@implementation TorrentController

-(id)initWithSevice:(CoreService *)service andTorrent:(Torrent *)torrent {
    self = [self initWithWindowNibName:@"TorrentWindow"];
    if (self) {
        _coreService = service;
        _torrent = torrent;
        [_torrent addObserver:self forKeyPath:@"fileStats" options:0 context:nil];
        [self prepeareTorrentFiles];
     }
    return self;
}

-(void)prepeareTorrentFiles {
    if (![[_torrent files] count]) {
        [[_coreService rpcAssistant] loadTorrentsDataForTorrentIdArray:@[_torrent]];
        [self performSelector:@selector(prepeareTorrentFiles) withObject:nil afterDelay:5.0];
    } else {
        _files = [self filesArrayFromTorrent:_torrent];
        self.filesTree = [self filesTreeFromFilesArray:_files];
    }
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

-(void)awakeFromNib {
    [_filesOutlineView expandItem:nil expandChildren:YES];
}

-(TorrentMoveController *)torrentMoveController {
    if (!_torrentMoveController) {
        _torrentMoveController = [[TorrentMoveController alloc] initWithSevice:_coreService andTorrent:_torrent];
    }
    return _torrentMoveController;
}

#pragma mark - Files

-(NSArray *)filesArrayFromTorrent:(Torrent *)torrent {
    NSUInteger count = [torrent.files count];
    NSMutableArray *filesArray = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        TorrentParentedFile *torrentFile = [[TorrentParentedFile alloc] init];
        [torrentFile setValuesForKeysWithDictionary:torrent.files[i]];
        [torrentFile setValuesForKeysWithDictionary:torrent.fileStats[i]];
        torrentFile.index = [NSString stringWithFormat:@"%ld", i];
        [filesArray addObject:torrentFile];
    }
    return filesArray;
}

-(NSArray *)filesArrayFromDictionary:(NSDictionary *)dictionary {
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *key in dictionary) {
        id item = [dictionary valueForKey:key];
        if ([item isKindOfClass:[TorrentParentedFile class]]) {
            [item setDisplayName:key];
            [items addObject:item];
        } else {
            TorrentParentedFile *folder = [[TorrentParentedFile alloc] init];
            folder.name = key;
            folder.displayName = key;
            folder.childs = [self filesArrayFromDictionary:item];
            [items addObject:folder];
        }
    }
    return items;
}

-(NSArray *)filesTreeFromFilesArray:(NSArray *)filesArray {
    NSString *separator = @"/";
    NSMutableDictionary *folders = [NSMutableDictionary dictionary];
    for (TorrentFile *file in filesArray) {
        NSArray *filepath = [file.name componentsSeparatedByString:separator];
        NSMutableDictionary *current = folders;
        NSUInteger count = [filepath count] - 1;
        for(NSUInteger i = 0; i <= count; ++i) {
            NSString *path = filepath[i];
            if (i == count) {
                [current setValue:file forKey:path];
            } else {
                NSMutableDictionary *folder = [current valueForKey:path];
                if (!folder) {
                    folder = [NSMutableDictionary dictionary];
                    [current setValue:folder forKey:path];
                }
                current = folder;
            }
        }
    }
    return [self filesArrayFromDictionary:folders];
}

-(void)updateFilesArrayWithStatisticsArray:(NSArray *)array {
    NSUInteger count = [_files count];
    if (array && [array count] == count) {
        @synchronized(_files) {
            for (NSUInteger i = 0; i < count; i++) {
                NSDictionary *dict = array[i];
                TorrentParentedFile *file = _files[i];
                NSUInteger bytesCompleted = [[dict valueForKey:@"bytesCompleted"] unsignedIntegerValue];
                if (file.bytesCompleted != bytesCompleted) {
                    file.bytesCompleted = bytesCompleted;
                }
                BOOL wanted = [[dict valueForKey:@"wanted"] boolValue];
                if (file.wanted != wanted) {
                    file.wanted = wanted;
                }
            }
        }
    }
}

-(NSArray *)arrayFromTorrentFile:(TorrentParentedFile *)torrentFile {
    if (torrentFile) {
        NSMutableArray *files = [NSMutableArray array];
        if (torrentFile.leaf) {
            [files addObject:torrentFile];
        } else {
            for (TorrentParentedFile *file in [torrentFile childs]) {
                if (file.leaf) {
                    [files addObject:file];
                } else {
                    [files addObjectsFromArray:[self arrayFromTorrentFile:file]];
                }
            }
        }
        return files;
    } else {
        return nil;
    }
}

-(NSArray *)indexesFromTorrentFile:(TorrentParentedFile *)torrentFile {
    return [[self arrayFromTorrentFile:torrentFile] valueForKeyPath:@"index"];
}

-(void)dealloc {
    [_torrent removeObserver:self forKeyPath:@"fileStats"];
}

#pragma mark - IB Actions

-(NSArray *)selectedFiles {
    NSInteger row = [_filesOutlineView clickedRow];
    if (row != -1 && ![_filesOutlineView isRowSelected:row]) {
        return @[[[_filesOutlineView itemAtRow:row] representedObject]];
    } else {
        return [_filesTreeController selectedObjects];
    }
}

-(void)closeTorrentWindow {
    [self.window orderOut:nil];
    [NSApp endSheet:self.window];
}

- (IBAction)applyChanges:(id)sender {
    [self closeTorrentWindow];
}

- (IBAction)enableFileAction:(id)sender {
    NSArray *selectedFiles = [self selectedFiles];
    NSMutableSet *ids = [NSMutableSet set];
    for (TorrentParentedFile *file in selectedFiles) {
        [ids addObjectsFromArray:[self indexesFromTorrentFile:file]];
    }
    NSArray *indexes = [ids allObjects];
    if ([indexes count] > 0) {
        [_coreService.rpcAssistant torrent:_torrent SetWantedFiles:indexes];
    }
}

- (IBAction)disableFileAction:(id)sender {
    NSArray *selectedObjects = [_filesTreeController selectedObjects];
    if ([selectedObjects count] > 0) {
        NSArray *indexes = [self indexesFromTorrentFile:[selectedObjects objectAtIndex:0]];
        [_coreService.rpcAssistant torrent:_torrent SetUnwantedFiles:indexes];
    }
}

- (IBAction)changeLocation:(id)sender {
    [NSApp beginSheet:self.torrentMoveController.window modalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
}

#pragma mark - Observing

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _torrent && [keyPath isEqualToString:@"fileStats"]) {
        [self updateFilesArrayWithStatisticsArray:_torrent.fileStats];
    }
}

@end
