//
//  RpcRequestHeader.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcRequestType.h"

@interface RpcRequestHeader : NSObject

@property (readonly) RpcRequestType requestType;
@property (readonly) NSString *requestBody;
@property (readonly) id data;

-(id)initWithType:(RpcRequestType)aType andBody:(NSString *)aBody;
-(id)initWithType:(RpcRequestType)aType andBody:(NSString *)aBody andData:(id)data;
+(id)requestHeaderWithType:(RpcRequestType)aType andBody:(NSString *)aBody;
+(id)requestHeaderWithType:(RpcRequestType)aType andBody:(NSString *)aBody andData:(id)data;

@end
