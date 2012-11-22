//
//  ServicedObject.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 16.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "ServicedObject.h"

@implementation ServicedObject

-(id)initWithService:(SystemService *)service {
    self = [self init];
    if (self) {
        _systemService = service;
    }
    return self;
}

@end
