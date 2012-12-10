//
//  RpcRequestHeader.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "RpcRequestHeader.h"

@implementation RpcRequestHeader

-(id)initWithType:(RpcRequestType)aType andBody:(NSString *)aBody {
    self = [super init];
    if (self) {
        _requestType = aType;
        _requestBody = aBody;
    }
    return self;
}

-(id)initWithType:(RpcRequestType)aType andBody:(NSString *)aBody andData:(id)data {
    self = [super init];
    if (self) {
        _requestType = aType;
        _requestBody = aBody;
        _data = data;
    }
    return self;
}

+(id)requestHeaderWithType:(RpcRequestType)aType andBody:(NSString *)aBody {
    return [[RpcRequestHeader alloc] initWithType:aType andBody:aBody];
}


+(id)requestHeaderWithType:(RpcRequestType)aType andBody:(NSString *)aBody andData:(id)data {
    return [[RpcRequestHeader alloc] initWithType:aType andBody:aBody andData:data];
}

@end
