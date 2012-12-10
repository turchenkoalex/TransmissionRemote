//
//  RpcRequestDelegate.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcRequestType.h"
#import "RpcRequestHeader.h"

@protocol RpcRequestDelegate <NSObject>

-(void)rpcRequestDidReceiveData:(NSData *)aData withHeader:(RpcRequestHeader *)header;
-(void)rpcRequestDidReceiveSessionId:(NSString *)aSessionId forRpcRequestHeader:(RpcRequestHeader *)aRequestHeader;
-(void)rpcRequestDidFailWithAuthorizationErrorForRpcRequestHeader:(RpcRequestHeader *)aRequestHeader;
-(void)rpcRequestDidFailWithError:(NSError *)error forRpcRequestHeader:(RpcRequestHeader *)aRequestHeader;

@end
