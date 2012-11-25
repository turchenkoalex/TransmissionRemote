//
//  TorrentItem+Viewable.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 25.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "TorrentItem+Viewable.h"
#import "NSNumber+UnitString.h"

@implementation TorrentItem (Viewable)

-(NSString *)humanizedItemSize {
    return [[NSNumber numberWithUnsignedInteger:self.itemSize] unitStringFromBytes];
}

-(NSString *)humanizedCompletedSize {
    return [[NSNumber numberWithUnsignedInteger:self.completedSize] unitStringFromBytes];
}

#pragma mark - KeyPathes

+(NSSet *)keyPathsForValuesAffectingHumanizedItemSize {
    return [NSSet setWithObjects:@"itemSize", nil];
}

+(NSSet *)keyPathsForValuesAffectingHumanizedCompletedSize {
    return [NSSet setWithObjects:@"completedSize", nil];
}

@end
