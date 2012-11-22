//
//  RpcProtocol.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 18.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcProtocolHandlerDelegate.h"

@interface RpcProtocol : NSObject {
    NSString *sessionGet;
    NSString *torrentsInitialize;
    NSString *torrentsUpdate;
    NSString *torrentsFullUpdate;
    NSString *torrentStop;
    NSString *torrentStart;
    NSString *torrentVerify;
    NSString *torrentRemove;
}

@property (weak) id <RpcProtocolHandlerDelegate> delegate;

-(id)initWithDelegate:(id <RpcProtocolHandlerDelegate>)aDelegate;

-(NSUInteger)sessionGetTag;
-(NSString *)sessionGetQuery;

-(NSUInteger)torrentGetInitializeTag;
-(NSString *)torrentGetInitializeQuery;

-(NSUInteger)torrentGetUpdateTag;
-(NSString *)torrentGetUpdateQuery;

-(NSUInteger)torrentGetFullUpdateTag;
-(NSString *)torrentGetFullUpdateQueryWithIds:(NSString *)aIds;

-(NSUInteger)torrentStopTag;
-(NSString *)torrentStopQueryWithIds:(NSString *)aIds;

-(NSUInteger)torrentStartTag;
-(NSString *)torrentStartQueryWithIds:(NSString *)aIds;

-(NSUInteger)torrentVerifyTag;
-(NSString *)torrentVerifyQueryWithIds:(NSString *)aIds;

-(NSUInteger)torrentRemoveTag;
-(NSString *)torrentRemoveQueryWithIds:(NSString *)aIds andDeleteLocalData:(BOOL)useDeleteLocalData;


-(BOOL)proceedResponse:(NSData *)aResponseData andTag:(NSUInteger)aTag;

@end
