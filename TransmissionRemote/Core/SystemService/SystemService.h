//
//  SystemService.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 15.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectOptions.h"

@interface SystemService : NSObject

@property ConnectOptions *connectOptions;

-(id)initWithDefaults;
-(void)applyConnectOptions:(ConnectOptions *)aConnectOptions;

-(void)connectWithDefaultConnectOptions;
-(void)connectWithConnectOptions:(ConnectOptions *)aConnectOptions;

@end
