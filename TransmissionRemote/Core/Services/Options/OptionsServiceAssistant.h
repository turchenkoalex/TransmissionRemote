//
//  OptionsServiceAssistant.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppOptions.h"
#import "ConnectOptions.h"

@interface OptionsServiceAssistant : NSObject

@property AppOptions *appOptions;
@property ConnectOptions *connectOptions;

-(void)loadDefaults;
-(void)updateCredentials;
-(BOOL)isConnectOptionsDefaultsChanged;

@end
