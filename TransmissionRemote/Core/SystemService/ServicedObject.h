//
//  ServicedObject.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 16.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemService.h"
#import "SystemServiced.h"

@interface ServicedObject : NSObject <SystemServiced>

@property (readonly, weak) SystemService *systemService;

@end
