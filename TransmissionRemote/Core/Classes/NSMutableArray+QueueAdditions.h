//
//  NSMutableArray+QueueAdditions.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 18.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAdditions)

-(id)dequeueObject;
-(void)enqueue:(id)anObject;

@end
