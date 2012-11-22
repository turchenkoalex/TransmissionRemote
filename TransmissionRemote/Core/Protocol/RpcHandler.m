//
//  RpcHandler.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 18.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "RpcHandler.h"
#import "RpcRequest.h"
#import "ServerStatus.h"

@implementation RpcHandler

-(id)init {
    self = [super init];
    if (self) {
        requestInterval = [NSNumber numberWithDouble:5.0];
        rpcProtocol = [[RpcProtocol alloc] initWithDelegate:self];
        [self registerNotifications];
    }
    return self;
}

-(id)initWithService:(SystemService *)service andConnectOptions:(ConnectOptions *)aConnectOptions {
    self = [self initWithService:service];
    if (self) {
        rpcURL = [aConnectOptions rpcURL];
        if ([aConnectOptions usingAuthorization]) {
            [self registerCredentialWithOptions:aConnectOptions];
        }
    }
    return self;
}

#pragma mark - Notifications

-(void)registerNotifications {
    [self unRegisterNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectRequestWithNotification:) name:@"ConnectRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionRequestWithNotification:) name:@"SessionRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTorrentsRequestWithNotification:) name:@"UpdateTorrentRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullUpdateTorrentsRequestWithNotification:) name:@"FullUpdateTorrentsRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRequestInterval:) name:@"UpdateRequestInterval" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(torrentsStopRequestWithNotification:) name:@"TorrentsStopRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(torrentsStartRequestWithNotification:) name:@"TorrentsStartRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(torrentsVerifyRequestWithNotification:) name:@"TorrentsVerifyRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(torrentsRemoveRequestWithNotification:) name:@"TorrentsRemoveRequest" object:nil];
}

-(void)updateRequestInterval:(NSNotification *)notification {
    NSNumber *interval = [notification object];
    if (interval) {
        @synchronized(requestInterval) {
            requestInterval = [interval copy];
        }
        [self performUpdateRequest];
    }
}

-(void)unRegisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)connectRequestWithNotification:(NSNotification *)notification {
    [self connect];
}

-(void)sessionRequestWithNotification:(NSNotification *)notification {
    [self sessionGet];
}

-(void)updateTorrentsRequestWithNotification:(NSNotification *)notification {
    [self torrentGetUpdate];
}

-(void)fullUpdateTorrentsRequestWithNotification:(NSNotification *)notification {
    NSString *ids = [notification object];
    if (ids) {
        [self torrentGetFullUpdateWithIds:ids];
    }
}

-(void)torrentsStopRequestWithNotification:(NSNotification *)notification {
    NSString *ids = [notification object];
    if (ids) {
        [self torrentsStopWithIds:ids];
    }
}

-(void)torrentsStartRequestWithNotification:(NSNotification *)notification {
    NSString *ids = [notification object];
    if (ids) {
        [self torrentsStartWithIds:ids];
    }
}

-(void)torrentsVerifyRequestWithNotification:(NSNotification *)notification {
    NSString *ids = [notification object];
    if (ids) {
        [self torrentsVerifyWithIds:ids];
    }
}

-(void)torrentsRemoveRequestWithNotification:(NSNotification *)notification {
    NSString *ids = [notification object];
    if (ids) {
        [self torrentsRemoveWithIds:ids andDeleteLocalData:YES];
    }
}

#pragma mark - Connections

-(void)connectWithConnectOptions:(ConnectOptions *)aConnectOptions {
    rpcURL = [aConnectOptions rpcURL];
    [self registerCredentialWithOptions:aConnectOptions];
    [self connect];    
}

-(void)connect {
    if (!connected) {
        ServerStatus *serverStatus = [[ServerStatus alloc] init];
        serverStatus.version = @"Connecting";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateServerStatusResponse" object:serverStatus];

        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(torrentGetUpdate) object:nil];
        connected = YES;
        sessionId = nil;
        [self sessionGet];
        [self torrentGetInitialize];
    }
}

-(void)performUpdateRequest {
    if (connected) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(torrentGetUpdate) object:nil];
        NSTimeInterval currentInterval = 5.0;
        @synchronized(requestInterval) {
            currentInterval = [requestInterval doubleValue];
        }
        [self performSelector:@selector(torrentGetUpdate) withObject:nil afterDelay:currentInterval];
    }
}

-(void)abortConnect {
    connected = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(torrentGetUpdate) object:nil];
    ServerStatus *serverStatus = [[ServerStatus alloc] init];
    serverStatus.version = @"Disconnected";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateServerStatusResponse" object:serverStatus];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InitializeTorrentsResponse" object:@[]];
}

#pragma mark - Request Logic

-(void)registerCredentialWithOptions:(ConnectOptions *)aConnectOptions {
    if ([aConnectOptions usingAuthorization]) {
        NSURLCredential *credential = [NSURLCredential credentialWithUser:aConnectOptions.username password:aConnectOptions.password persistence:NSURLCredentialPersistenceForSession];
        NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:aConnectOptions.server port:aConnectOptions.port protocol:aConnectOptions.protocol realm:aConnectOptions.realm authenticationMethod:nil];
        [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credential forProtectionSpace:protectionSpace];
    }
}

#pragma mark - RPC requests

-(RpcRequest *)requestWithData:(NSString *)aData andTag:(NSUInteger)aTag {
    RpcRequest *request = [[RpcRequest alloc] initWithURL:rpcURL withTag:aTag withJsonRequest:aData andDelegate:self];
    [request requestWithSession:sessionId];
    return request;
}

-(void)sessionGet {
    [self requestWithData:[rpcProtocol sessionGetQuery] andTag:[rpcProtocol sessionGetTag]];
}

-(void)torrentGetInitialize {
    [self requestWithData:[rpcProtocol torrentGetInitializeQuery] andTag:[rpcProtocol torrentGetInitializeTag]];
}

-(void)torrentGetUpdate {
    [self requestWithData:[rpcProtocol torrentGetUpdateQuery] andTag:[rpcProtocol torrentGetUpdateTag]];
}

-(void)torrentGetFullUpdateWithIds:(NSString *)aIds {
    [self requestWithData:[rpcProtocol torrentGetFullUpdateQueryWithIds:aIds] andTag:[rpcProtocol torrentGetFullUpdateTag]];
}

-(void)torrentsStopWithIds:(NSString *)aIds {
    [self requestWithData:[rpcProtocol torrentStopQueryWithIds:aIds] andTag:[rpcProtocol torrentStopTag]];
}

-(void)torrentsStartWithIds:(NSString *)aIds {
    [self requestWithData:[rpcProtocol torrentStartQueryWithIds:aIds] andTag:[rpcProtocol torrentStartTag]];
}

-(void)torrentsVerifyWithIds:(NSString *)aIds {
    [self requestWithData:[rpcProtocol torrentVerifyQueryWithIds:aIds] andTag:[rpcProtocol torrentVerifyTag]];
}

-(void)torrentsRemoveWithIds:(NSString *)aIds andDeleteLocalData:(BOOL)useDeleteLocalData {
    [self requestWithData:[rpcProtocol torrentRemoveQueryWithIds:aIds andDeleteLocalData:useDeleteLocalData] andTag:[rpcProtocol torrentRemoveTag]];
}

#pragma mark - <ReceiveDataDelegate>

-(void)didDataReceived:(NSData *)aData withTag:(NSUInteger)aTag {
    [rpcProtocol proceedResponse:aData andTag:aTag];
}

-(void)didSessionIdReceived:(NSString *)aSessionId onRpcRequest:(id)aRequest {
    sessionId = [aSessionId copy];
    RpcRequest *request = aRequest;
    if (sessionId) {
        [request requestWithSession:sessionId];
    } else {
        [self abortConnect];
    }
}

-(void)didFailWithAuthorizationErrorOnRpcRequest:(id)aRequest {
    NSLog(@"Request %@: Authorization error", aRequest);
    [self abortConnect];

    ServerStatus *serverStatus = [[ServerStatus alloc] init];
    serverStatus.version = @"Authorization error";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateServerStatusResponse" object:serverStatus];
    
}

-(void)didFailWithError:(NSError *)error onRpcRequest:(id)aRequest {
    NSLog(@"Request %@: %@", aRequest, error);
    [self abortConnect];
}

#pragma mark - <RpcProtocolHandlerDelegate>

-(void)didRequestReceivedWithTag:(NSUInteger)aTag {
    if (aTag == [rpcProtocol torrentGetUpdateTag] || aTag == [rpcProtocol torrentGetInitializeTag]) {
        [self performUpdateRequest];
    }
}

@end
