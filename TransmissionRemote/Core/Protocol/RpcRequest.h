//
//  RpcRequest.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 18.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcHandler.h"
#import "RequestReceieverDelegate.h"

@interface RpcRequest : NSObject <NSURLConnectionDataDelegate> {
    NSMutableData *recievedData;
    NSUInteger tag;
    NSURLRequest *request;
}

@property (weak) id <RequestReceieverDelegate> delegate;

-(id)initWithURL:(NSURL*)aURL withTag:(NSUInteger)aTag withJsonRequest:(NSString *)aJsonRequest andDelegate:(id <RequestReceieverDelegate>)aDelegate;
-(void)requestWithSession:(NSString *)aSession;

@end
