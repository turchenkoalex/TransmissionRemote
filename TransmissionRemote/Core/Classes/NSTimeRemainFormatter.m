//
//  NSTimeRemainFormatter.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 28.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "NSTimeRemainFormatter.h"

@implementation NSTimeRemainFormatter

-(id)init {
    self = [super init];
    if (self) {
        systemCalendar = [NSCalendar currentCalendar];
        originDate = [[NSDate alloc] init];
        unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        numberFormatter = [[NSNumberFormatter alloc] init];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        systemCalendar = [NSCalendar currentCalendar];
        originDate = [[NSDate alloc] init];
        unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setMinimumIntegerDigits:2];
    }
    return self;
}

-(NSString *)stringForObjectValue:(id)obj {
    NSTimeInterval timeRemain = [obj doubleValue];
    if (timeRemain <= 0.0) {
        return nil;
    } else {
        NSDate *diffedDate = [[NSDate alloc] initWithTimeInterval:timeRemain sinceDate:originDate];
        NSDateComponents *remainInfo = [systemCalendar components:unitFlags fromDate:originDate toDate:diffedDate options:0];
        if ([remainInfo hour]) {
            return [NSString stringWithFormat:@"%ld:%@:%@", [remainInfo hour], [numberFormatter stringFromNumber:[NSNumber numberWithInteger:[remainInfo minute]]], [numberFormatter stringFromNumber:[NSNumber numberWithInteger:[remainInfo second]]]];
        } else {
            return [NSString stringWithFormat:@"%@:%@", [numberFormatter stringFromNumber:[NSNumber numberWithInteger:[remainInfo minute]]], [numberFormatter stringFromNumber:[NSNumber numberWithInteger:[remainInfo second]]]];
        }
    }
}

-(BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error {
    return NO;
}

@end
