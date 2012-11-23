//
//  SystemServiced.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 15.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@protocol Serviced <NSObject>

@property (readonly) Service *service;

-(id)initWithService:(Service *)service;

@end
