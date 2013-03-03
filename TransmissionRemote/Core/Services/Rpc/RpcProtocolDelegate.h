//
//  RpcProtocolDelegate.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 21.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerStatus.h"
@class RpcRequestHeader;

@protocol RpcProtocolDelegate <NSObject>

-(void)rpcProtocolDidReceiveInitializedTorrents:(NSArray *)torrents;
-(void)rpcProtocolDidReceiveUpdatedTorrents:(NSArray *)torrents;
-(void)rpcProtocolDidReceiveRemovedTorrentIdArray:(NSArray *)torrents;
-(void)rpcProtocolDidReceiveLoadedTorrents:(NSArray *)torrents;
-(void)rpcProtocolDidReceiveAddedTorrentId:(NSString *)torrentId;
-(void)rpcProtocolDidReceiveServerStatus:(ServerStatus *)serverStatus;
-(void)rpcProtocolDidReceiveChangeOfTorrent:(NSString *)torrentId;
-(void)rpcProtocolDidReceiveChangeOfTorrents:(NSArray *)torrentIdArray;
-(void)rpcProtocolDidReceiveDuplicateTorrentError:(RpcRequestHeader *)requestHeader;

@end
