//
//  NSNumber+UnitString.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 23.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "NSNumber+UnitString.h"

@implementation NSNumber (HumanizedSize)

-(NSString *)unitStringFromBytes {
    int multiplier = 1024;
    int exponent = 0;
    
    double bytes = [self doubleValue];
    
    while (bytes >= multiplier && exponent < maxUnits) {
        bytes /= multiplier;
        exponent++;
    }
    
    return [NSString stringWithFormat:@"%.2f %cB", bytes, units[exponent]];
}

@end
