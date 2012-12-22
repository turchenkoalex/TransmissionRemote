//
//  RpcProtocol.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "RpcProtocol.h"
#import "ServerStatus.h"

@implementation RpcProtocol

-(id)init {
    self = [super init];
    if (self) {
        _sessionGetHeader = [RpcRequestHeader requestHeaderWithType:REQUEST_SESSION_GET andBody:[self jsonStringFromDictionary:@{ @"method": @"session-get" }]];
        NSArray *initFields = @[@"id", @"name", @"status", @"comment", @"percentDone", @"recheckProgress", @"uploadRatio", @"totalSize", @"files", @"fileStats", @"rateDownload", @"rateUpload", @"leftUntilDone", @"eta", @"peersConnected", @"queuePosition", @"downloadDir"];
        _torrentsInitializeHeader = [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_INIT andBody:[self jsonStringFromDictionary:@{@"method": @"torrent-get", @"arguments": @{ @"fields": initFields } }]];
        NSArray *updateFields = @[@"id", @"status", @"percentDone", @"recheckProgress", @"uploadRatio", @"rateDownload", @"rateUpload", @"leftUntilDone", @"fileStats", @"eta", @"peersConnected", @"queuePosition"];
        _torrentsUpdate = [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_UPDATE andBody:[self jsonStringFromDictionary:@{@"method": @"torrent-get", @"arguments": @{ @"fields": updateFields, @"ids": @"recently-active" } }]];
        _torrentsFullUpdateBody = [NSString stringWithFormat:@"{ \"method\": \"torrent-get\", \"arguments\": { \"fields\" : [\"%@\"], \"ids\": [%@] } }", [initFields componentsJoinedByString:@"\",\""], @"%@"];
        _torrentsUpdateByIds = [NSString stringWithFormat:@"{ \"method\": \"torrent-get\", \"arguments\": { \"fields\" : [\"%@\"], \"ids\": [%@] } }", [updateFields componentsJoinedByString:@"\",\""], @"%@"];
        
        _torrentStopBody = @"{ \"method\": \"torrent-stop\", \"arguments\": { \"ids\": [%@] } }";
        _torrentStartBody = @"{ \"method\": \"torrent-start\", \"arguments\": { \"ids\": [%@] } }";
        _torrentStartNowBody = @"{ \"method\": \"torrent-start-now\", \"arguments\": { \"ids\": [%@] } }";
        _torrentVerifyBody = @"{ \"method\": \"torrent-verify\", \"arguments\": { \"ids\": [%@] } }";
        _torrentRemoveBody = @"{ \"method\": \"torrent-remove\", \"arguments\": { \"ids\": [%@], \"delete-local-data\": %@ } }";
        _torrentAddFileBody = @"{ \"method\": \"torrent-add\", \"arguments\": { \"paused\": %@, \"metainfo\": \"%@\" } }";
        _torrentAddUrlBody = @"{ \"method\": \"torrent-add\", \"arguments\": { \"paused\": %@, \"filename\": \"%@\" } }";
        _torrentSetFilesWanted = @"{ \"method\": \"torrent-set\", \"arguments\": { \"ids\": [%@], \"files-wanted\": [%@] } }";
        _torrentSetFilesUnwanted = @"{ \"method\": \"torrent-set\", \"arguments\": { \"ids\": [%@], \"files-unwanted\": [%@] } }";
        _torrentSetLocation = @"{ \"method\": \"torrent-set-location\", \"arguments\": { \"ids\": [%@], \"location\": \"%@\", \"move\": %@ } }";
    }
    return self;
}

-(id)initWithDelegate:(id <RpcProtocolDelegate>)aDelegate {
    self = [self init];
    if (self) {
        _delegate = aDelegate;
    }
    return self;
}

#pragma mark - Query Builder

-(NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error) {
        NSLog(@"Json Build Error: %@", error);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

#pragma mark - Helpers

-(NSString *)stringFromBOOL:(BOOL)aBool {
    return aBool ? @"true" : @"false";
}

#pragma mark - Request

-(RpcRequestHeader *) sessionGetRequest {
    return _sessionGetHeader;
}

-(RpcRequestHeader *) sessionSetRequestWithStatus:(ServerStatus *)status {
    return [RpcRequestHeader requestHeaderWithType:REQUEST_SESSION_SET andBody:[self jsonStringFromDictionary:@{ @"method": @"session-set", @"arguments": @{ @"alt-speed-enabled": [self stringFromBOOL:status.speedLimit] } }]];
}

-(RpcRequestHeader *) torrentsInitializeRequest {
    return _torrentsInitializeHeader;
}

-(RpcRequestHeader *) torrentsUpdateRequest {
    return _torrentsUpdate;
}

-(RpcRequestHeader *) torrentsFullUpdateRequestWithTorrentIdArray:(NSArray *)torrentIdArray {
    return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_FULLUPDATE andBody:[NSString stringWithFormat:_torrentsFullUpdateBody, [torrentIdArray componentsJoinedByString:@","]]];
}

-(RpcRequestHeader *) torrentsStopRequestWithTorrentIdArray:(NSArray *)torrentIdArray {
    return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_STOP andBody:[NSString stringWithFormat:_torrentStopBody, [torrentIdArray componentsJoinedByString:@","]]];
}

-(RpcRequestHeader *) torrentsStartRequestWithTorrentIdArray:(NSArray *)torrentIdArray andRequiring:(BOOL)requiredNow {
    if (requiredNow) {
        return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_START andBody:[NSString stringWithFormat:_torrentStartNowBody, [torrentIdArray componentsJoinedByString:@","]]];
    } else {
        return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_START andBody:[NSString stringWithFormat:_torrentStartBody, [torrentIdArray componentsJoinedByString:@","]]];
    }
}

-(RpcRequestHeader *) torrentsVerifyRequestWithTorrentIdArray:(NSArray *)torrentIdArray {
    return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_VERIFY andBody:[NSString stringWithFormat:_torrentVerifyBody, [torrentIdArray componentsJoinedByString:@","]]];
}

-(RpcRequestHeader *) torrentsRemoveRequestWithTorrentIdArray:(NSArray *)torrentIdArray andRemoveLocalData:(BOOL)removeLocalData {
    return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_REMOVE andBody:[NSString stringWithFormat:_torrentRemoveBody, [torrentIdArray componentsJoinedByString:@","], [self stringFromBOOL:removeLocalData]]];
}

-(RpcRequestHeader *) torrentsAddTorrentRequestWithData:(NSString *)torrentData andStart:(BOOL)start{
    return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_ADD andBody:[NSString stringWithFormat:_torrentAddFileBody, [self stringFromBOOL:!start], torrentData]];
}

-(RpcRequestHeader *) torrentsAddTorrentRequestWithURL:(NSString *)url andStart:(BOOL)start {
    return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_ADD andBody:[NSString stringWithFormat:_torrentAddUrlBody, [self stringFromBOOL:!start], url]];
}

-(RpcRequestHeader *) torrent:(Torrent *)torrent SetWantedFiles:(NSArray *)filesIndexes {
    NSString *indexes = [filesIndexes componentsJoinedByString:@","];
    return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_SET andBody:[NSString stringWithFormat:_torrentSetFilesWanted, torrent.id, indexes] andData:torrent.id];
}

-(RpcRequestHeader *) torrent:(Torrent *)torrent SetUnwantedFiles:(NSArray *)filesIndexes {
    NSString *indexes = [filesIndexes componentsJoinedByString:@","];
    return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_SET andBody:[NSString stringWithFormat:_torrentSetFilesUnwanted, torrent.id, indexes] andData:torrent.id];
}

-(RpcRequestHeader *) torrentsUpdateRequestWithTorrentIdArray:(NSArray *)torrentIdArray {
    return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_UPDATE andBody:[NSString stringWithFormat:_torrentsUpdateByIds, [torrentIdArray componentsJoinedByString:@","]]];
}

-(RpcRequestHeader *) torrents:(NSArray *)torrents setLocation:(NSString *)location andMove:(BOOL)move {
    return [RpcRequestHeader requestHeaderWithType:REQUEST_TORRENT_LOCATION andBody:[NSString stringWithFormat:_torrentSetLocation, [torrents componentsJoinedByString:@","], location, [self stringFromBOOL:move]] andData:[torrents valueForKeyPath:@"id"]];
}

#pragma mark - Response

-(NSArray *)torrentsArrayFromDictionary:(NSDictionary *)dictionary {
    if (dictionary) {
        NSMutableArray *torrents = [NSMutableArray arrayWithCapacity:[dictionary count]];
        for (id item in dictionary) {
            Torrent *torrent = [[Torrent alloc] init];
            [torrent setValuesForKeysWithDictionary:item];
            [torrents addObject:torrent];
        }
        return torrents;
    } else {
        return nil;
    }
}

-(BOOL)proceedRequest:(RpcRequestHeader *)header andData:(NSData *)aData {
    NSError *error;
    id jsonData = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"Serialization error: %@\n%@", error, [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding]);
        return NO;
    } else {
        BOOL success = [[jsonData valueForKey:@"result"] isEqualToString:@"success"];
        if (success) {
            // success request
            NSDictionary *arguments = [jsonData valueForKey:@"arguments"];
            if (arguments && _delegate) {
                // proceed data
                switch (header.requestType) {
                    case REQUEST_TORRENT_UPDATE: {
                        [_delegate rpcProtocolDidReceiveUpdatedTorrents:[self torrentsArrayFromDictionary:[arguments valueForKey:@"torrents"]]];
                        NSArray *numberIdsArray = [arguments valueForKey:@"removed"];
                        if (numberIdsArray && [numberIdsArray count] > 0) {
                            [_delegate rpcProtocolDidReceiveRemovedTorrentIdArray:numberIdsArray];
                        }
                    }
                        break;
                    case REQUEST_TORRENT_FULLUPDATE:
                        [_delegate rpcProtocolDidReceiveLoadedTorrents:[self torrentsArrayFromDictionary:[arguments valueForKey:@"torrents"]]];
                        break;
                    case REQUEST_TORRENT_INIT:
                        [_delegate rpcProtocolDidReceiveInitializedTorrents:[self torrentsArrayFromDictionary:[arguments valueForKey:@"torrents"]]];
                        break;
                    case REQUEST_SESSION_GET: {
                            ServerStatus *serverStatus = [[ServerStatus alloc] init];
                            serverStatus.connected = YES;
                            serverStatus.downloadDirectory = [arguments objectForKey:@"download-dir"];
                            serverStatus.version = [NSString stringWithFormat:@"Transmission %@", [arguments objectForKey:@"version"]];
                            serverStatus.speedLimit = [[arguments objectForKey:@"alt-speed-enabled"] boolValue];
                            [_delegate rpcProtocolDidReceiveServerStatus:serverStatus];
                        }
                        break;
                    case REQUEST_TORRENT_ADD:
                        [_delegate rpcProtocolDidReceiveAddedTorrentId:[[arguments valueForKey:@"torrent-added"] valueForKey:@"id"]];
                        break;
                    case REQUEST_TORRENT_SET:
                        if (header.data) {
                            [_delegate rpcProtocolDidReceiveChangeOfTorrent:header.data];
                        }
                        break;
                    case REQUEST_TORRENT_LOCATION:
                        if (header.data) {
                            [_delegate rpcProtocolDidReceiveChangeOfTorrents:header.data];
                        }
                    default:
                        break;
                }
            }
        } else {
            // error request
            NSLog(@"Response result error: %@", [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding]);
        }
        return success;
    }
}


@end
