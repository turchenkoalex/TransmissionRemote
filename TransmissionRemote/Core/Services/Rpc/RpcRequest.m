//
//  RpcRequest.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "RpcRequest.h"

@implementation RpcRequest

+(id)requestForURL:(NSURL*)anURL header:(RpcRequestHeader *)aHeader sessionId:(NSString *)aSessionId andDelegate:(id <RpcRequestDelegate>)aDelegate {
    return [[RpcRequest alloc] initForURL:anURL header:aHeader sessionId:aSessionId andDelegate:aDelegate];
}

-(id)initForURL:(NSURL*)anURL header:(RpcRequestHeader *)aHeader sessionId:(NSString *)aSessionId andDelegate:(id <RpcRequestDelegate>)aDelegate {
    self = [self init];
    if (self) {
        _delegate = aDelegate;
        _requestHeader = aHeader;
        NSMutableURLRequest *mutableUrlRequest = [NSMutableURLRequest requestWithURL:anURL];
        [mutableUrlRequest setHTTPMethod:@"POST"];
        [mutableUrlRequest setHTTPBody:[_requestHeader.requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        if (aSessionId) {
            [mutableUrlRequest setValue:aSessionId forHTTPHeaderField:@"X-Transmission-Session-Id"];
        }
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:mutableUrlRequest delegate:self];
        if (connection) {
            _receivedData = [NSMutableData data];
        }
    }
    return self;
}

#pragma mark - <NSURLConnectionDataDelegate>

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    NSInteger statusCode = [response statusCode];
    if (statusCode == 409) {
        // SessionID Received
        if (_delegate) {
            NSString *sessionId = [[response allHeaderFields] valueForKey:@"X-Transmission-Session-Id"];
            [_delegate rpcRequestDidReceiveSessionId:sessionId forRpcRequestHeader:_requestHeader];
        }
        [connection cancel];
    } else if (statusCode == 401) {
        // Authorization Error
        if (_delegate) {
            [_delegate rpcRequestDidFailWithAuthorizationErrorForRpcRequestHeader:_requestHeader];
        }
        [connection cancel];
    } else {
        [_receivedData setLength:0];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (_delegate) {
        [_delegate rpcRequestDidFailWithError:error forRpcRequestHeader:_requestHeader];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (_delegate) {
        [_delegate rpcRequestDidReceiveData:_receivedData withHeader:_requestHeader];
    }
}

@end
