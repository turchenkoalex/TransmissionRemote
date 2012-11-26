//
//  TorrentItem+Viewable.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 25.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "TorrentItem+Viewable.h"

@implementation TorrentItem (Viewable)

-(NSString *)humanizedItemSize {
    return [NSByteCountFormatter stringFromByteCount:self.itemSize countStyle:NSByteCountFormatterCountStyleBinary];
}

-(NSString *)humanizedCompletedSize {
    if (self.itemSize) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setMinimum:[NSNumber numberWithInt:0]];
        [formatter setMaximum:[NSNumber numberWithInt:100]];
        [formatter setMinimumIntegerDigits:1];
        [formatter setMaximumFractionDigits:2];
        return [NSString stringWithFormat:@"%@ %%", [formatter stringFromNumber:[NSNumber numberWithDouble:(100.00 * self.completedSize / self.itemSize)]]];
    } else {
        return @"∞";
    }
}

-(BOOL)isLeaf {
    return (!self.childs);
}

#pragma mark - KeyPathes

+(NSSet *)keyPathsForValuesAffectingHumanizedItemSize {
    return [NSSet setWithObjects:@"itemSize", nil];
}

+(NSSet *)keyPathsForValuesAffectingHumanizedCompletedSize {
    return [NSSet setWithObjects:@"completedSize", nil];
}

@end
