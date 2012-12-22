//
//  RpcServiceAssistant.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "RpcServiceAssistant.h"
#import "RpcRequest.h"
#import "NSData+Base64.h"

@implementation RpcServiceAssistant

-(id)init {
    self = [super init];
    if (self) {
        _sessionId = nil;
    }
    return self;
}

-(id)initWithDelegate:(id<RpcServiceAssistantDelegate>)aDelegate andProtocolDelegate:(id <RpcProtocolDelegate>)protocolDelegate{
    self = [self init];
    if (self) {
        _delegate = aDelegate;
        _rpcProtocol = [[RpcProtocol alloc] initWithDelegate:protocolDelegate];
    }
    return self;
}

#pragma marl - Request Logic

-(void)sendRequestWithHeader:(RpcRequestHeader *)requestHeader {
    [RpcRequest requestForURL:[_delegate rpcServiceURL] header:requestHeader sessionId:_sessionId andDelegate:self];
}

#pragma mark - RPC Actions

-(void)getServerStatus {
    [self sendRequestWithHeader:[_rpcProtocol sessionGetRequest]];
}

-(void)setServerStatus:(ServerStatus *)serverStatus {
    [self sendRequestWithHeader:[_rpcProtocol sessionSetRequestWithStatus:serverStatus]];
}

-(void)initializeTorrents {
    [self sendRequestWithHeader:[_rpcProtocol torrentsInitializeRequest]];
}

-(void)updateRecentlyChangedTorrents {
    [self sendRequestWithHeader:[_rpcProtocol torrentsUpdateRequest]];
}

-(void)loadTorrentsDataForTorrentIdArray:(NSArray *)torrentIdArray {
    [self sendRequestWithHeader:[_rpcProtocol torrentsFullUpdateRequestWithTorrentIdArray:torrentIdArray]];
}

-(void)startTorrentsArray:(NSArray *)torrents rightNow:(BOOL)now {
    [self sendRequestWithHeader:[_rpcProtocol torrentsStartRequestWithTorrentIdArray:torrents andRequiring:now]];
}

-(void)stopTorrentsArray:(NSArray *)torrents {
    [self sendRequestWithHeader:[_rpcProtocol torrentsStopRequestWithTorrentIdArray:torrents]];
}

-(void)recheckTorrentsArray:(NSArray *)torrents {
    [self sendRequestWithHeader:[_rpcProtocol torrentsVerifyRequestWithTorrentIdArray:torrents]];
}

-(void)removeTorrentsArray:(NSArray *)torrents withLocalData:(BOOL)removeLocalData {
    [self sendRequestWithHeader:[_rpcProtocol torrentsRemoveRequestWithTorrentIdArray:torrents andRemoveLocalData:removeLocalData]];
}

-(void)torrent:(Torrent *)torrent SetWantedFiles:(NSArray *)filesIndexes {
    [self sendRequestWithHeader:[_rpcProtocol torrent:torrent SetWantedFiles:filesIndexes]];
}

-(void)torrent:(Torrent *)torrent SetUnwantedFiles:(NSArray *)filesIndexes {
    [self sendRequestWithHeader:[_rpcProtocol torrent:torrent SetUnwantedFiles:filesIndexes]];
}

-(void)updateTorrentsDataForTorrentIdArray:(NSArray *)torrentIdArray {
    [self sendRequestWithHeader:[_rpcProtocol torrentsUpdateRequestWithTorrentIdArray:torrentIdArray]];
}

-(void)addTorrentWithMetadata:(NSData *)metadata andStart:(BOOL)start {
    [self sendRequestWithHeader:[_rpcProtocol torrentsAddTorrentRequestWithData:[metadata encodeToBase64String] andStart:start]];
}

-(void)addTorrentWithURL:(NSString *)url andStart:(BOOL)start {
    [self sendRequestWithHeader:[_rpcProtocol torrentsAddTorrentRequestWithURL:url andStart:start]];
}

-(void)torrents:(NSArray *)torrents setLocation:(NSString *)location andMove:(BOOL)move {
    [self sendRequestWithHeader:[_rpcProtocol torrents:torrents setLocation:location andMove:move]];
}

#pragma mark - <RpcRequestDelegate>

-(void)rpcRequestDidReceiveData:(NSData *)aData withHeader:(RpcRequestHeader *)header {
    [_rpcProtocol proceedRequest:header andData:aData];
}

-(void)rpcRequestDidReceiveSessionId:(NSString *)aSessionId forRpcRequestHeader:(RpcRequestHeader *)aRequestHeader {
    if (aSessionId) {
        _sessionId = aSessionId;
        [self sendRequestWithHeader:aRequestHeader];
    }
}

-(void)rpcRequestDidFailWithAuthorizationErrorForRpcRequestHeader:(RpcRequestHeader *)aRequestHeader {
    NSLog(@"FailWithAuthorizationErrorForRpcRequestHeader: %@", aRequestHeader);
}

-(void)rpcRequestDidFailWithError:(NSError *)error forRpcRequestHeader:(RpcRequestHeader *)aRequestHeader {
    NSLog(@"FailWithError: %@", error);
}

@end
