//
//  RequestReceieverDelegate.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 18.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestReceieverDelegate <NSObject>

-(void)didDataReceived:(NSData *)aData withTag:(NSUInteger)aTag;
-(void)didSessionIdReceived:(NSString *)aSessionId onRpcRequest:(id)aRequest;
-(void)didFailWithAuthorizationErrorOnRpcRequest:(id)aRequest;
-(void)didFailWithError:(NSError *)error onRpcRequest:(id)aRequest;

@end
