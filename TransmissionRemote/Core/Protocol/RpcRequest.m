//
//  RpcRequest.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 18.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "RpcRequest.h"

@implementation RpcRequest

-(id)initWithURL:(NSURL*)aURL withTag:(NSUInteger)aTag withJsonRequest:(NSString *)aJsonRequest andDelegate:(id <RequestReceieverDelegate>)aDelegate {
    self = [self init];
    if (self) {
        _delegate = aDelegate;
        tag = aTag;
        NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:aURL];
        [mutableRequest setHTTPMethod:@"POST"];
        [mutableRequest setHTTPBody:[aJsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
        request = [mutableRequest copy];
    }
    return self;
}

-(void)requestWithSession:(NSString *)aSession {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    if (aSession) {
        [mutableRequest setValue:aSession forHTTPHeaderField:@"X-Transmission-Session-Id"];
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:mutableRequest delegate:self];
    if (connection) {
        recievedData = [NSMutableData data];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    NSInteger statusCode = [response statusCode];
    if (statusCode == 409) {
        // SessionID Received
        if (_delegate) {
            NSString *sessionId = [[response allHeaderFields] valueForKey:@"X-Transmission-Session-Id"];
            [_delegate didSessionIdReceived:sessionId onRpcRequest:self];
        }
        [connection cancel];
    } else if (statusCode == 401) {
        // Authorization Error
        if (_delegate) {
            [_delegate didFailWithAuthorizationErrorOnRpcRequest:self];
        }
        [connection cancel];
    } else {
        [recievedData setLength:0];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [recievedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (_delegate) {
        [_delegate didFailWithError:error onRpcRequest:self];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (_delegate) {
        [_delegate didDataReceived:recievedData withTag:tag];
    }
}

@end
