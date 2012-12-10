//
//  RpcRequest.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcRequestDelegate.h"
#import "RpcRequestHeader.h"

@interface RpcRequest : NSObject <NSURLConnectionDataDelegate> {
    NSMutableData *_receivedData;
    RpcRequestHeader *_requestHeader;
    id <RpcRequestDelegate> _delegate;
}

-(id)initForURL:(NSURL*)anURL header:(RpcRequestHeader *)aHeader sessionId:(NSString *)aSessionId andDelegate:(id <RpcRequestDelegate>)aDelegate;
+(id)requestForURL:(NSURL*)anURL header:(RpcRequestHeader *)aHeader sessionId:(NSString *)aSessionId andDelegate:(id <RpcRequestDelegate>)aDelegate;

@end
