//
//  RpcServiceAssistantDelegate.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RpcServiceAssistantDelegate <NSObject>

-(NSURL *)rpcServiceURL;
-(void)requestFailedWithAuthorizationError;
-(void)request:(RpcRequestHeader *)requestHeader failedWithError:(NSError *)error;

@end
