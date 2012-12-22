//
//  RpcProtocol.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcProtocolDelegate.h"
#import "RpcRequestHeader.h"
#import "Torrent.h"

@interface RpcProtocol : NSObject {
    id <RpcProtocolDelegate> _delegate;
    
    //default request bodies
    RpcRequestHeader *_sessionGetHeader;
    RpcRequestHeader *_torrentsInitializeHeader;
    RpcRequestHeader *_torrentsUpdate;
    
    NSString *_torrentsFullUpdateBody;
    NSString *_torrentStopBody;
    NSString *_torrentStartBody;
    NSString *_torrentStartNowBody;
    NSString *_torrentVerifyBody;
    NSString *_torrentRemoveBody;
    NSString *_torrentAddFileBody;
    NSString *_torrentAddUrlBody;
    NSString *_torrentsUpdateByIds;
    NSString *_torrentSetFilesWanted;
    NSString *_torrentSetFilesUnwanted;
    NSString *_torrentSetLocation;
}

-(id)initWithDelegate:(id <RpcProtocolDelegate>)aDelegate;

#pragma mark - Request

-(RpcRequestHeader *) sessionGetRequest;
-(RpcRequestHeader *) sessionSetRequestWithStatus:(ServerStatus *)status;
-(RpcRequestHeader *) torrentsInitializeRequest;
-(RpcRequestHeader *) torrentsUpdateRequest;
-(RpcRequestHeader *) torrentsFullUpdateRequestWithTorrentIdArray:(NSArray *)torrentIdArray;
-(RpcRequestHeader *) torrentsStopRequestWithTorrentIdArray:(NSArray *)torrentIdArray;
-(RpcRequestHeader *) torrentsStartRequestWithTorrentIdArray:(NSArray *)torrentIdArray andRequiring:(BOOL)requiredNow;
-(RpcRequestHeader *) torrentsVerifyRequestWithTorrentIdArray:(NSArray *)torrentIdArray;
-(RpcRequestHeader *) torrentsRemoveRequestWithTorrentIdArray:(NSArray *)torrentIdArray andRemoveLocalData:(BOOL)removeLocalData;
-(RpcRequestHeader *) torrentsAddTorrentRequestWithData:(NSString *)torrentData andStart:(BOOL)start;
-(RpcRequestHeader *) torrentsAddTorrentRequestWithURL:(NSString *)url andStart:(BOOL)start;
-(RpcRequestHeader *) torrent:(Torrent *)torrent SetWantedFiles:(NSArray *)filesIndexes;
-(RpcRequestHeader *) torrent:(Torrent *)torrent SetUnwantedFiles:(NSArray *)filesIndexes;
-(RpcRequestHeader *) torrentsUpdateRequestWithTorrentIdArray:(NSArray *)torrentIdArray;
-(RpcRequestHeader *) torrents:(NSArray *)torrents setLocation:(NSString *)location andMove:(BOOL)move;

#pragma mark - Response

-(BOOL)proceedRequest:(RpcRequestHeader *)header andData:(NSData *)aData;

@end
