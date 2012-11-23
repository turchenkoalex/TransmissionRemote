//
//  NSNumber+UnitString.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 23.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

static const char units[] = { '\0', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y' };
static const int maxUnits = sizeof units - 1;

@interface NSNumber (HumanizedSize)

-(NSString *)unitStringFromBytes;

@end
