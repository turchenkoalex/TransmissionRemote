//
//  CoreService.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcServiceAssistant.h"
#import "OptionsServiceAssistant.h"
#import "TorrentsServiceAssistant.h"
#import "TorrentServiceAssistantDelegate.h"
#import "ServerStatus.h"

@interface CoreService : NSObject <RpcServiceAssistantDelegate, TorrentServiceAssistantDelegate> {
    NSNumber *_refreshInterval;
    NSMutableArray *_filesQueue;
    NSMutableArray *_urlsQueue;
    NSMutableSet *_watingAddTorrents;
}

@property (readonly) OptionsServiceAssistant *optionsAssistant;
@property (readonly) TorrentsServiceAssistant *torrentsAssistant;
@property (readonly) ServerStatus *serverStatus;
@property (readonly) RpcServiceAssistant *rpcAssistant;
@property NSUInteger rateDownload;
@property NSUInteger rateUpload;

-(void)start;
-(void)connect;
-(void)disconnect;

-(void)activityUp;
-(void)activityDown;
-(void)addTorrentFiles:(NSArray *)filenames;
-(void)addTorrentURL:(NSString *)url;

@end
