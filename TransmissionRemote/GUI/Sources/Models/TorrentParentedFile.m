//
//  TorrentParentedFile.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 09.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "TorrentParentedFile.h"

@implementation TorrentParentedFile

-(void)cleanupObserving {
    if (_childs) {
        for (TorrentParentedFile *child in _childs) {
            [child removeObserver:self forKeyPath:@"wanted"];
        }
    }
}

-(void)dealloc {
    [self cleanupObserving];
}

-(NSArray *)childs {
    return _childs;
}

-(void)setChilds:(NSArray *)childs {
    [self cleanupObserving];
    if (childs) {
        self.length = 0;
        self.bytesCompleted = 0;
        self.wanted = NO;
        for(TorrentParentedFile *child in childs) {
            self.length += child.length;
            self.bytesCompleted += child.bytesCompleted;
            self.wanted |= child.wanted;
            [child addObserver:self forKeyPath:@"wanted" options:0 context:nil];
        }
    }
    _childs = childs;
}

-(BOOL)leaf {
    return (!_childs);
}

-(double)completedPercent {
    return self.length ? (double)self.bytesCompleted / self.length : 0;
}

#pragma mark - KeyPaths

+(NSSet *)keyPathsForValuesAffectingLeaf {
    return [NSSet setWithObject:@"childs"];
}

+(NSSet *)keyPathsForValuesAffectingCompletedPercent {
    return [NSSet setWithObjects:@"bytesCompleted", @"length", nil];
}

#pragma mark - Observing

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"wanted"]) {
        if ([object wanted]) {
            if (!self.wanted) {
                self.wanted = YES;
            }
        } else {
            BOOL newWanted = NO;
            for (TorrentParentedFile *item in self.childs) {
                if (item.wanted) {
                    newWanted = YES;
                    break;
                }
            }
            if (self.wanted != newWanted) {
                self.wanted = newWanted;
            }
        }
    }
}

@end
