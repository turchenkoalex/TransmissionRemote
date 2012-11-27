//
//  TorrentItem+Viewable.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 25.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "TorrentItem+Viewable.h"

@implementation TorrentItem (Viewable)

-(double)completedPercent {
    return self.itemSize ? (double)self.completedSize / self.itemSize : 0;
}

-(BOOL)isLeaf {
    return (!self.childs);
}

#pragma mark - KeyPathes

+(NSSet *)keyPathsForValuesAffectingCompletedPercent {
    return [NSSet setWithObjects:@"completedSize", @"itemSize", nil];
}

@end
