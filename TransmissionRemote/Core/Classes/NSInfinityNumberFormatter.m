//
//  NSInfinityNumberFormatter.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 27.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "NSInfinityNumberFormatter.h"

@implementation NSInfinityNumberFormatter

-(id)init{
    self = [super init];
    if (self) {
        infinitySymbol = @"∞";
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        infinitySymbol = @"∞";
    }
    return self;
}

-(NSString *)stringForObjectValue:(id)obj {
    if (obj && [obj isEqual:@-1.0]) {
        return infinitySymbol;
    } else {
        return [super stringForObjectValue:obj];
    }
}

@end
