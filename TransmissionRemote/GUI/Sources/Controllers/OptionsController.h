//
//  OptionsController.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 06.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CoreService.h"

@interface OptionsController : NSWindowController <NSWindowDelegate>

@property (readonly) CoreService *coreService;

-(id)initWithService:(CoreService *)service;

@end
