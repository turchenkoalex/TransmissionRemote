//
//  NSInfinityNumberFormatter.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 27.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "NSInfinityNumberFormatter.h"

@implementation NSInfinityNumberFormatter

-(NSString *)stringForObjectValue:(id)obj {
    if (obj && [obj isEqual:@-1.0]) {
        return @"∞";
    } else {
        return [super stringForObjectValue:obj];
    }
}

@end
