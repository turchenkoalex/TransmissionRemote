//
//  RpcServiceAssistant.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcProtocol.h"
#import "RpcRequestDelegate.h"
#import "RpcServiceAssistantDelegate.h"

@interface RpcServiceAssistant : NSObject <RpcRequestDelegate> {
    RpcProtocol *_rpcProtocol;
    NSString *_sessionId;
    id <RpcServiceAssistantDelegate> _delegate;
}

-(id)initWithDelegate:(id<RpcServiceAssistantDelegate>)aDelegate andProtocolDelegate:(id <RpcProtocolDelegate>)protocolDelegate;

#pragma mark - RPC Actions

-(void)getServerStatus;
-(void)setServerStatus:(ServerStatus *)serverStatus;
-(void)initializeTorrents;
-(void)updateRecentlyChangedTorrents;
-(void)loadTorrentsDataForTorrentIdArray:(NSArray *)torrentIdArray;
-(void)startTorrentsArray:(NSArray *)torrents rightNow:(BOOL)now;
-(void)stopTorrentsArray:(NSArray *)torrents;
-(void)recheckTorrentsArray:(NSArray *)torrents;
-(void)removeTorrentsArray:(NSArray *)torrents withLocalData:(BOOL)removeLocalData;
-(void)torrent:(Torrent *)torrent SetWantedFiles:(NSArray *)filesIndexes;
-(void)torrent:(Torrent *)torrent SetUnwantedFiles:(NSArray *)filesIndexes;
-(void)updateTorrentsDataForTorrentIdArray:(NSArray *)torrentIdArray;
-(void)addTorrentWithMetadata:(NSData *)metadata andStart:(BOOL)start;
-(void)addTorrentWithURL:(NSString *)url andStart:(BOOL)start;
-(void)torrents:(NSArray *)torrents setLocation:(NSString *)location andMove:(BOOL)move;

@end
