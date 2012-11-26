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
    return [NSByteCountFormatter stringFromByteCount:self.completedSize countStyle:NSByteCountFormatterCountStyleBinary];
}

#pragma mark - KeyPathes

+(NSSet *)keyPathsForValuesAffectingHumanizedItemSize {
    return [NSSet setWithObjects:@"itemSize", nil];
}

+(NSSet *)keyPathsForValuesAffectingHumanizedCompletedSize {
    return [NSSet setWithObjects:@"completedSize", nil];
}

@end
