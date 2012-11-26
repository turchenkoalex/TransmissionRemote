//
//  RpcProtocol.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 18.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "RpcProtocol.h"
#import "ServerStatus.h"
#import "Torrent.h"
#import "TorrentItem.h"

@implementation RpcProtocol

-(id)init {
    self = [super init];
    if (self) {
        NSArray *fullTorrentFields = @[@"id", @"name", @"status", @"comment", @"percentDone", @"recheckProgress", @"uploadRatio", @"totalSize", @"files", @"fileStats"];
        NSArray *torrentFields = @[@"id", @"status", @"percentDone", @"recheckProgress", @"uploadRatio"];
        
        sessionGet = [self jsonQuery:@{ @"method": @"session-get" }];
        torrentsInitialize = [self jsonQuery:@{@"method": @"torrent-get", @"arguments": @{ @"fields": fullTorrentFields } }];
        torrentsUpdate = [self jsonQuery:@{@"method": @"torrent-get", @"arguments": @{ @"fields": torrentFields, @"ids": @"recently-active" } }];

        torrentsFullUpdate = [NSString stringWithFormat:@"{ \"method\": \"torrent-get\", \"arguments\": { \"fields\" : [\"%@\"], \"ids\": [%@] } }", [fullTorrentFields componentsJoinedByString:@"\",\""], @"%@"];
        
        torrentStop = @"{ \"method\": \"torrent-stop\", \"arguments\": { \"ids\": [%@] } }";
        torrentStart = @"{ \"method\": \"torrent-start\", \"arguments\": { \"ids\": [%@] } }";
        torrentStartNow = @"{ \"method\": \"torrent-start-now\", \"arguments\": { \"ids\": [%@] } }";
        torrentVerify = @"{ \"method\": \"torrent-verify\", \"arguments\": { \"ids\": [%@] } }";
        torrentRemove = @"{ \"method\": \"torrent-remove\", \"arguments\": { \"ids\": [%@], \"delete-local-data\": %@ } }";
        torrentAddFile = @"{ \"method\": \"torrent-add\", \"arguments\": { \"paused\": true, \"metainfo\": \"%@\" } }";
        torrentAddUrl = @"{ \"method\": \"torrent-add\", \"arguments\": { \"paused\": true, \"filename\": \"%@\" } }";
    }
    return self;
}

-(id)initWithDelegate:(id <RpcProtocolHandlerDelegate>)aDelegate {
    self = [self init];
    if (self) {
        self.delegate = aDelegate;
    }
    return self;
}

#pragma mark - Query Builder

-(NSString *)jsonQuery:(NSDictionary *)dictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error) {
        NSLog(@"Json Error: %@", error);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

#pragma mark - Requests session-get
-(NSUInteger)sessionGetTag {
    return 1;
}

-(NSString *)sessionGetQuery {
    return sessionGet;
}

#pragma mark - Requests session-set

-(NSUInteger)sessionSetTag {
    return 2;
}

-(NSString *)sessionSetQueryWithStatus:(ServerStatus *)status {
    return [self jsonQuery:@{ @"method": @"session-set", @"arguments": @{ @"alt-speed-enabled": status.alternativeSpeed ? @"true" : @"false" } }];
}

#pragma mark - Requests torrent-get

-(NSUInteger)torrentGetInitializeTag {
    return 3;
}
-(NSString *)torrentGetInitializeQuery {
    return torrentsInitialize;
}

-(NSUInteger)torrentGetUpdateTag {
    return 4;
}

-(NSString *)torrentGetUpdateQuery {
    return torrentsUpdate;
}

-(NSUInteger)torrentGetFullUpdateTag {
    return 5;
}

-(NSString *)torrentGetFullUpdateQueryWithIds:(NSString *)aIds {
    return [NSString stringWithFormat:torrentsFullUpdate, aIds];
}

-(NSUInteger)torrentStopTag {
    return 6;
}

-(NSString *)torrentStopQueryWithIds:(NSString *)aIds {
    return [NSString stringWithFormat:torrentStop, aIds];
}

-(NSUInteger)torrentStartTag {
    return 7;
}

-(NSString *)torrentStartQueryWithIds:(NSString *)aIds {
    return [NSString stringWithFormat:torrentStart, aIds];
}

-(NSUInteger)torrentStartNowTag {
    return 7;
}

-(NSString *)torrentStartNowQueryWithIds:(NSString *)aIds {
    return [NSString stringWithFormat:torrentStartNow, aIds];
}


-(NSUInteger)torrentVerifyTag {
    return 8;
}

-(NSString *)torrentVerifyQueryWithIds:(NSString *)aIds {
    return [NSString stringWithFormat:torrentVerify, aIds];
}

-(NSUInteger)torrentRemoveTag {
    return 9;
}

-(NSString *)torrentRemoveQueryWithIds:(NSString *)aIds andDeleteLocalData:(BOOL)useDeleteLocalData {
    return [NSString stringWithFormat:torrentRemove, aIds, useDeleteLocalData ? @"true" : @"false"];
}

-(NSUInteger)torrentAddFileTag {
    return 10;
}

-(NSString *)torrentAddFileQueryWithData:(NSString *)fileData {
    return [NSString stringWithFormat:torrentAddFile, fileData];
}


#pragma mark - Proceeding response

-(NSArray *)torrentItemsFor:(NSArray *)files andStats:(NSArray *)stats{
    if (files) {
        NSUInteger count = [files count];
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:count];
        for(NSUInteger i = 0; i < count; ++i) {
            id item = [files objectAtIndex:i];
            id stat = [stats objectAtIndex:i];
            TorrentItem *torrentItem = [[TorrentItem alloc] init];
            torrentItem.itemName = [item valueForKey:@"name"];
            torrentItem.itemSize = [[item valueForKey:@"length"] unsignedIntegerValue];
            torrentItem.completedSize = [[item valueForKey:@"bytesCompleted"] unsignedIntegerValue];
            torrentItem.enabled = [stat boolForKey:@"wanted"];
            [items addObject:torrentItem];
        }
        return [items copy];
    } else {
        return nil;
    }
}

-(Torrent *)torrentFromObject:(id)aObject {
    Torrent *torrent = [[Torrent alloc] init];
    torrent.torrentId = [[aObject valueForKey:@"id"] integerValue];
    torrent.torrentName = [[aObject valueForKey:@"name"] copy];
    torrent.torrentComment = [aObject valueForKey:@"comment"];
    torrent.torrentState = [[aObject valueForKey:@"status"] shortValue];
    torrent.torrentDownloadPercent = [[aObject valueForKey:@"percentDone"] doubleValue] * 100;
    torrent.torrentVerifyPercent = [[aObject valueForKey:@"recheckProgress"] doubleValue] * 100;
    torrent.uploadRatio = [[aObject valueForKey:@"uploadRatio"] doubleValue];
    torrent.totalSize = [[aObject valueForKey:@"totalSize"] unsignedIntegerValue];
    torrent.items = [self torrentItemsFor:[aObject valueForKey:@"files"] andStats:[aObject valueForKey:@"fileStats"]];
    return torrent;
}

-(NSMutableArray *)torrentsFromDictionary:(NSDictionary *)aDictionary {
    if (aDictionary) {
        NSMutableArray *torrents = [NSMutableArray arrayWithCapacity:[aDictionary count]];
        for (id item in aDictionary) {
            [torrents addObject:[self torrentFromObject:item]];
        }
        return torrents;
    } else {
        return nil;
    }
}


-(BOOL)proceedResponse:(NSData *)aResponseData andTag:(NSUInteger)aTag {
    NSError *error;
    id jsonData = [NSJSONSerialization JSONObjectWithData:aResponseData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"Serialization error: %@\n%@", error, [[NSString alloc] initWithData:aResponseData encoding:NSUTF8StringEncoding]);
        return NO;
    } else {
        BOOL success = [[jsonData valueForKey:@"result"] isEqualToString:@"success"];
        if (success) {
            // success request
            NSDictionary *arguments = [jsonData valueForKey:@"arguments"];
            if (arguments) {
                [self procceedResult:arguments withTag:aTag];
            }
        } else {
            // error request
            NSLog(@"Response result error: %@", [[NSString alloc] initWithData:aResponseData encoding:NSUTF8StringEncoding]);
        }
        return success;
    }
}

-(void)procceedResult:(NSDictionary *)aResult withTag:(NSUInteger)aTag {
    switch (aTag) {
        case 4:
            // torrent-get update
            [self proceedTorrentUpdateGetResult:aResult];
            break;

        case 5:
            // torrent-get fullUpdate
            [self proceedTorrentFullUpdateGetResult:aResult];
            break;
            
        case 1:
            // session-get
            [self proceedSessionGetResult:aResult];
            break;

        case 2:
            // session-set
            //[self proceedSessionGetResult:aResult];
            break;
            
        case 3:
            // torrent-get initialize
            [self proceedTorrentInitializeGetResult:aResult];
            break;
            
        case 6:
            // torrent-stop
        case 7:
            // torrent-start
        case 8:
            // torrent-verify
        case 9:
            // torrent-remove
            break;
        case 10:
            // torrent-add
            [self proceedAddTorrentGetResult:aResult];
            break;
            
        default:
            // unknown request
            break;
    }
}

-(void)proceedSessionGetResult:(NSDictionary *)aResult {
    if (aResult) {
        ServerStatus *serverStatus = [[ServerStatus alloc] init];
        serverStatus.connected = YES;
        serverStatus.version = [NSString stringWithFormat:@"Transmission %@", [aResult objectForKey:@"version"]];
        serverStatus.alternativeSpeed = [[aResult objectForKey:@"alt-speed-enabled"] boolValue];
        if (_delegate) {
            [_delegate didSessionGetRequestReceived:serverStatus];
        }
    }
}

-(void)proceedTorrentInitializeGetResult:(NSDictionary *)aResult {
    if (_delegate) {
        [_delegate didInitializeTorrentsRequestReceived:[self torrentsFromDictionary:[aResult valueForKey:@"torrents"]]];
    }
}

-(void)proceedTorrentUpdateGetResult:(NSDictionary *)aResult {
    if (_delegate) {
        [_delegate didUpdateTorrentsRequestReceived:[self torrentsFromDictionary:[aResult valueForKey:@"torrents"]]];
        [_delegate didRemovedTorrentsRequestReceived:[aResult valueForKey:@"removed"]];
    }
}



-(void)proceedTorrentFullUpdateGetResult:(NSDictionary *)aResult {
    if (_delegate) {
        [_delegate didFullUpdateTorrentsRequestReceived:[self torrentsFromDictionary:[aResult valueForKey:@"torrents"]]];
    }
}

-(void)proceedAddTorrentGetResult:(NSDictionary *)aResult {
    if (_delegate) {
        [_delegate didAddTorrentsRequestReceived:[[[aResult valueForKey:@"torrent-added"] valueForKey:@"id"] unsignedIntegerValue]];
    }
}

@end
