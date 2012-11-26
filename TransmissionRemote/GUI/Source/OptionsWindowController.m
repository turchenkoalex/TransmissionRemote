//
//  OptionsWindowController.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 17.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "OptionsWindowController.h"

@interface OptionsWindowController ()

@end

@implementation OptionsWindowController

-(id) initWithService:(Service *)service {
    self = [super initWithWindowNibName:@"OptionsWindow"];
    if (self) {
        _service = service;
    }
    return self;
}

-(id)initWithWindow:(NSWindow *)window {
    return [super initWithWindow:window];
}

-(void)showWindow:(id)sender {
    self.connectOptions = [self.service.connectOptions mutableCopy];
    self.appOptions = [self.service.appOptions mutableCopy];
    [NSApp beginSheet:self.window modalForWindow:sender modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)saveOptions:(id)sender {
    [self.service applyConnectOptions:self.connectOptions];
    [self.service applyAppOptions:self.appOptions];
    [self closeWindow:sender];
}

- (IBAction)closeWindow:(id)sender {
    [self.window orderOut:nil];
    [NSApp endSheet:self.window];
}


@end
