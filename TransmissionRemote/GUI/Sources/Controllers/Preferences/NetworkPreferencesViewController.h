//
//  NetworkPreferencesViewController.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 10.02.13.
//  Copyright (c) 2013 TurchenkoAlex. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "CoreService.h"

@interface NetworkPreferencesViewController : NSViewController <MASPreferencesViewController>

@property (nonatomic, readonly) CoreService *coreService;

-(id)initWithService:(CoreService *)service;

@end
