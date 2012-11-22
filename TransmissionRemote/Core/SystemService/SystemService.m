//
//  SystemService.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 15.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "SystemService.h"
#import "RpcHandler.h"

@interface SystemService () {
    RpcHandler *rpcHandler;
}

@end

@implementation SystemService

-(id)init {
    self = [super init];
    if (self) {
        _connectOptions = [[ConnectOptions alloc] init];
        rpcHandler = [[RpcHandler alloc] initWithService:self];
    }
    return self;
}

-(id)initWithDefaults {
    self = [self init];
    if (self) {
        _connectOptions = [self loadConnectOptions];
    }
    return self;
}

#pragma mark - Storing and Loading User Settings

-(id)loadObjectForKey:(NSString *)key {
    NSData *objectData = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    if (objectData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
    } else {
        return nil;
    }
}

-(void)saveObject:(id <NSCoding>)theObject withKey:(NSString *)key {
    NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:theObject];
    if (objectData) {
        [[NSUserDefaults standardUserDefaults] setObject:objectData forKey:key];
    }
}

-(void)applyConnectOptions:(ConnectOptions *)aConnectOptions {
    self.connectOptions = [aConnectOptions copy];
    [self saveConnectOptions:self.connectOptions];
    [rpcHandler abortConnect];
    [rpcHandler connectWithConnectOptions:aConnectOptions];
}

-(ConnectOptions *)loadConnectOptions {
    ConnectOptions *connectOptions = [self loadObjectForKey:@"ConnectOptions"];
    if (!connectOptions) {
        connectOptions = [[ConnectOptions alloc] init];
    }
    return connectOptions;
}

-(void)saveConnectOptions:(ConnectOptions *)aConnectOptions {
    [self saveObject:aConnectOptions withKey:@"ConnectOptions"];
}

#pragma mark - Connections

-(void)connectWithDefaultConnectOptions {
    [self connectWithConnectOptions:_connectOptions];
}

-(void)connectWithConnectOptions:(ConnectOptions *)aConnectOptions {
    [rpcHandler connectWithConnectOptions:aConnectOptions];
}

@end
