//
//  Torrent+Viewable.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 16.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "Torrent+Viewable.h"
#import "TorrentItem+Viewable.h"

@implementation Torrent (Viewable)

-(NSString *)torrentIdString {
    return [NSString stringWithFormat:@"%ld", self.torrentId];
}

-(NSImage *)statusImage {
    return [NSImage imageNamed:[TorrentStatusImageNames[self.torrentState] copy]];
}

-(double)torrentComplete {
    if (self.torrentState == STATE_CHECK_WAIT || self.torrentState == STATE_CHECK) {
        return self.torrentVerifyPercent;
    } else {
        return self.torrentDownloadPercent;
    }
}

-(double)estimatedTime {
    return self.rateDownload ? self.leftUntilDone / self.rateDownload : -1.0;
}

-(NSArray *)arrayFrom:(NSDictionary *)dictionary {
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *key in dictionary) {
        id item = [dictionary valueForKey:key];
        if ([item isKindOfClass:[TorrentItem class]]) {
            [items addObject:item];
        } else {
            TorrentItem *torrentItem = [[TorrentItem alloc] init];
            torrentItem.itemName = key;
            torrentItem.childs = [self arrayFrom:item];
            torrentItem.enabled = NO;
            if (torrentItem.childs) {
                for(TorrentItem *subItem in torrentItem.childs) {
                    torrentItem.itemSize += subItem.itemSize;
                    torrentItem.completedSize += subItem.completedSize;
                    torrentItem.enabled |= subItem.enabled;
                }
            }
            [items addObject:torrentItem];
        }
    }
    return [items copy];
}

-(NSArray *)treeOfTorrentItemsFromArray:(NSArray *)array {
    if (array) {
        NSString *separator = @"/";
        NSMutableDictionary *folders = [NSMutableDictionary dictionary];
        for (TorrentItem *item in array) {
            NSArray *filepath = [item.itemName componentsSeparatedByString:separator];
            NSMutableDictionary *current = folders;
            NSUInteger count = [filepath count] - 1;
            for(NSUInteger i = 0; i <= count; ++i) {
                NSString *path = filepath[i];
                if (i == count) {
                    [current setValue:item forKey:path];
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
        return [self arrayFrom:folders];
    } else {
        return nil;
    }
}

-(NSArray *)files {
    return [self treeOfTorrentItemsFromArray:self.items];
}


#pragma mark - State properties

-(BOOL)isActive {
    return self.torrentState != STATE_STOPPED;
}

-(BOOL)isDownloading {
    return (self.torrentState == STATE_DOWNLOAD);
}

-(BOOL)isSeeding {
    return (self.torrentState == STATE_SEED);
}

-(BOOL)isStopped {
    return (self.torrentState == STATE_STOPPED);
}

-(BOOL)isVerifing {
    return (self.torrentState == STATE_CHECK);
}

-(BOOL)isWaiting {
    return (self.torrentState == STATE_CHECK_WAIT || self.torrentState == STATE_SEED_WAIT || self.torrentState == STATE_DOWNLOAD_WAIT || self.torrentState == STATE_CHECK);
}

#pragma mark - KeyPathes

+(NSSet *)keyPathsForValuesAffectingTorrentIdString {
    return [NSSet setWithObjects:@"torrentId", nil];
}

+(NSSet *)keyPathsForValuesAffectingStatusImage {
    return [NSSet setWithObjects:@"torrentState", nil];
}

+(NSSet *)keyPathsForValuesAffectingTorrentComplete {
    return [NSSet setWithObjects:@"torrentDownloadPercent", @"torrentVerifyPercent", nil];
}

+(NSSet *)keyPathsForValuesAffectingIsSeeding {
    return [NSSet setWithObjects:@"torrentState", nil];
}

+(NSSet *)keyPathsForValuesAffectingIsStopped {
    return [NSSet setWithObjects:@"torrentState", nil];
}

+(NSSet *)keyPathsForValuesAffectingIsVerifing {
    return [NSSet setWithObjects:@"torrentState", nil];
}

+(NSSet *)keyPathsForValuesAffectingIsDownloading {
    return [NSSet setWithObjects:@"torrentState", nil];
}

+(NSSet *)keyPathsForValuesAffectingIsActive {
    return [NSSet setWithObjects:@"torrentState", nil];
}

+(NSSet *)keyPathsForValuesAffectingEstimatedTime {
    return [NSSet setWithObjects:@"rateDownload", @"leftUntilDone", nil];
}

@end
