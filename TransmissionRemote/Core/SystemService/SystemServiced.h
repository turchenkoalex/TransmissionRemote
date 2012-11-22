//
//  SystemServiced.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 15.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemService.h"

@protocol SystemServiced <NSObject>

@property (readonly) SystemService *systemService;

-(id)initWithService:(SystemService *)service;

@end
