//
//  ConnectOptions.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 15.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "ConnectOptions.h"

@implementation ConnectOptions

-(id)init {
    self = [super init];
    if (self) {
        self.server = @"localhost";
        self.realm = @"Transmission";
        self.rpcPath = @"transmission";
        self.port = 9091;
    }
    return self;
}

-(NSString *)protocol {
    if (_usingSSL) {
        return @"https";
    } else {
        return @"http";
    }
}

-(NSURL *)rpcURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@:%ld/%@/rpc", [self protocol], _server, _port, _rpcPath]];
}

-(void)apply:(ConnectOptions *)fromOptions {
    self.server = [fromOptions.server copy];
    self.port = fromOptions.port;
    self.usingSSL = fromOptions.usingSSL;
    self.usingAuthorization = fromOptions.usingAuthorization;
    self.username = [fromOptions.username copy];
    self.password = [fromOptions.password copy];
}

#pragma mark - <NSCopying>

-(id)copyWithZone:(NSZone *)zone {
    ConnectOptions *copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        [copy apply:self];
    }
    return copy;
}

#pragma mark - <NSMutableCopying>

-(id)mutableCopyWithZone:(NSZone *)zone {
    ConnectOptions *copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        [copy apply:self];
    }
    return copy;
}

#pragma mark - <NSCoding>

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [[[self class] alloc] init];
    if (self) {
        _server = [aDecoder decodeObjectForKey:@"server"];
        _port = [aDecoder decodeIntegerForKey:@"port"];
        _usingSSL = [aDecoder decodeBoolForKey:@"usingSSL"];
        _usingAuthorization = [aDecoder decodeBoolForKey:@"usingAuthorization"];
        _username = [aDecoder decodeObjectForKey:@"username"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _rpcPath = [aDecoder decodeObjectForKey:@"rpcPath"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_server forKey:@"server"];
    [aCoder encodeInteger:_port forKey:@"port"];
    [aCoder encodeBool:_usingSSL forKey:@"usingSSL"];
    [aCoder encodeBool:_usingAuthorization forKey:@"usingAuthorization"];
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_rpcPath forKey:@"rpcPath"];
}

@end
