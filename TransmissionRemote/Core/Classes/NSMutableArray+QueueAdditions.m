//
//  NSMutableArray+QueueAdditions.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 18.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "NSMutableArray+QueueAdditions.h"

@implementation NSMutableArray (QueueAdditions)

-(id)dequeueObject {
    if (self.count > 0) {
        id headObject = [self objectAtIndex:0];
        [self removeObjectAtIndex:0];
        return headObject;
    } else {
        return nil;
    }
}

-(void)enqueue:(id)anObject {
    [self addObject:anObject];
}

@end
