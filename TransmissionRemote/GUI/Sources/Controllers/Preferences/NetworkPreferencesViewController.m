//
//  NetworkPreferencesViewController.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 10.02.13.
//  Copyright (c) 2013 TurchenkoAlex. All rights reserved.
//

#import "NetworkPreferencesViewController.h"

@interface NetworkPreferencesViewController ()

@end

@implementation NetworkPreferencesViewController

-(id)initWithService:(CoreService *)service {
    self = [self initWithNibName:@"NetworkPreferencesView" bundle:nil];
    if (self) {
        _coreService = service;
    }
    return self;    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark -
#pragma mark MASPreferencesViewController

-(NSString *)identifier {
    return @"NetworkPreferences";
}

-(NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNameNetwork];
}

-(NSString *)toolbarItemLabel {
    return NSLocalizedString(@"Network", @"Toolbar item name for the Network preference pane");
}

-(BOOL)commitEditing {
    if ([_coreService.optionsAssistant isConnectOptionsDefaultsChanged] || ![_coreService.serverStatus connected]) {
        [_coreService disconnect];
        [_coreService connect];
    }
    return YES;
}

@end
