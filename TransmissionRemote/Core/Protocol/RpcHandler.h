//
//  RpcHandler.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 18.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "ServicedObject.h"
#import "RpcProtocol.h"
#import "RequestReceieverDelegate.h"
#import "RpcProtocolHandlerDelegate.h"

@interface RpcHandler : ServicedObject <RequestReceieverDelegate, RpcProtocolHandlerDelegate> {
    NSString *sessionId;
    RpcProtocol *rpcProtocol;
    NSURL *rpcURL;
    BOOL connected;
    BOOL inProcess;
    NSNumber *requestInterval;
}

-(id)initWithService:(Service *)service andConnectOptions:(ConnectOptions *)aConnectOptions;
-(void)connectWithConnectOptions:(ConnectOptions *)aConnectOptions;
-(void)connect;
-(void)abortConnect;

@end
