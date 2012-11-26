//
//  SystemService.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 15.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectOptions.h"
#import "AppOptions.h"

@interface Service : NSObject

@property ConnectOptions *connectOptions;
@property AppOptions *appOptions;

-(id)initWithDefaults;
-(void)applyConnectOptions:(ConnectOptions *)aConnectOptions;
-(void)applyAppOptions:(AppOptions *)aAppOptions;

-(void)connectWithDefaultConnectOptions;
-(void)connectWithConnectOptions:(ConnectOptions *)aConnectOptions;

@end
