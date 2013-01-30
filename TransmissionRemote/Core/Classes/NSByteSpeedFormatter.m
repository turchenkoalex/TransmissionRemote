//
//  NSByteSpeedFormatter.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 28.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "NSByteSpeedFormatter.h"

@implementation NSByteSpeedFormatter

-(NSString *)stringForObjectValue:(id)obj {
    return [self stringFromByteCount:[obj unsignedIntegerValue]];
}

-(NSString *)stringFromByteCount:(long long)byteCount {
    if (byteCount <= 1000) {
        return [NSString stringWithFormat:NSLocalizedString(@"Bytes per second", "Speed"), byteCount];
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"Size per second", "Speed"), [super stringFromByteCount:byteCount]];
    }
}

@end
