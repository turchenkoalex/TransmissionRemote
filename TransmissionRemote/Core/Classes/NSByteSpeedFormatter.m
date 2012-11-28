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
    return [NSString stringWithFormat:@"%@/s", [super stringForObjectValue:obj]];
}

@end
