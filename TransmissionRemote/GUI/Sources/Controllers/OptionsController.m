//
//  OptionsController.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 06.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "OptionsController.h"

@interface OptionsController ()

@end

@implementation OptionsController

-(id)initWithService:(CoreService *)service {
    self = [self initWithWindowNibName:@"OptionsWindow"];
    if (self) {
        _coreService = service;
    }
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(BOOL)windowShouldClose:(id)sender {
    if ([_coreService.optionsAssistant isConnectOptionsDefaultsChanged]) {
        [_coreService disconnect];
        [_coreService connect];
    }
    return YES;
}

@end
