//
//  OptionsServiceAssistant.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "OptionsServiceAssistant.h"

@implementation OptionsServiceAssistant

-(id)init {
    self = [super init];
    if (self) {
        self.appOptions = [[AppOptions alloc] init];
        self.connectOptions = [[ConnectOptions alloc] init];
    }
    return self;
}

-(void)updateCredentials {
    if ([_connectOptions usingAuthorization]) {
        NSURLCredential *credential = [NSURLCredential credentialWithUser:_connectOptions.username password:_connectOptions.password persistence:NSURLCredentialPersistenceForSession];
        NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:_connectOptions.server port:_connectOptions.port protocol:_connectOptions.protocol realm:_connectOptions.realm authenticationMethod:nil];
        [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credential forProtectionSpace:protectionSpace];
    }
}

-(void)loadDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.connectOptions.server = [defaults stringForKey:@"server"];
    self.connectOptions.port = [defaults integerForKey:@"port"];
    self.connectOptions.usingSSL = [defaults boolForKey:@"usingSSL"];
    self.connectOptions.usingAuthorization = [defaults boolForKey:@"usingAuthorization"];
    self.connectOptions.username = [defaults stringForKey:@"username"];
    self.connectOptions.password = [defaults stringForKey:@"password"];
    
    self.appOptions.removeFilesAfterAddingTorrent = [defaults boolForKey:@"removeFilesAfterAddingTorrent"];
    self.appOptions.removeTorrentWithLocalData = [defaults boolForKey:@"removeTorrentWithLocalData"];
    self.appOptions.startTorrentAfterAdding = [defaults boolForKey:@"startTorrentAfterAdding"];
}

-(BOOL)isConnectOptionsDefaultsChanged {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return
        (![self.connectOptions.server isEqualToString:[defaults stringForKey:@"server"]]) ||
        (self.connectOptions.port != [defaults integerForKey:@"port"]) ||
        (self.connectOptions.usingSSL != [defaults boolForKey:@"usingSSL"]) ||
        (self.connectOptions.usingAuthorization != [defaults boolForKey:@"usingAuthorization"]) ||
        (![self.connectOptions.username isEqualToString:[defaults stringForKey:@"username"]]) ||
        (![self.connectOptions.password isEqualToString:[defaults stringForKey:@"password"]]);
    
}

@end
