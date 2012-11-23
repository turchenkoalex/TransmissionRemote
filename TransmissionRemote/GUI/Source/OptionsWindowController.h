//
//  OptionsWindowController.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 17.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Serviced.h"
#import "ConnectOptions.h"

@interface OptionsWindowController : NSWindowController <Serviced>

@property (readonly) Service *service;
@property ConnectOptions *connectOptions;

- (IBAction)saveOptions:(id)sender;
- (IBAction)closeWindow:(id)sender;

@end
