//
//  ServicedObject.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 16.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "Serviced.h"

@interface ServicedObject : NSObject <Serviced>

@property (readonly, weak) Service *service;

@end
