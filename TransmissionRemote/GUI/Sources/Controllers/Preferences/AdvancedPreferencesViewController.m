//
//  AdvancedPreferencesViewController.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 10.02.13.
//  Copyright (c) 2013 TurchenkoAlex. All rights reserved.
//

#import "AdvancedPreferencesViewController.h"

@interface AdvancedPreferencesViewController ()

@end

@implementation AdvancedPreferencesViewController

-(id)init {
    self = [self initWithNibName:@"AdvancedPreferencesView" bundle:nil];
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

- (NSString *)identifier {
    return @"AdvancedPreferences";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel {
    return NSLocalizedString(@"Advanced", @"Toolbar item name for the Advanced preference pane");
}

@end
