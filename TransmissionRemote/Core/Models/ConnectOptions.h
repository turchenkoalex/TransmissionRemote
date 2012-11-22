//
//  ConnectOptions.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 15.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectOptions : NSObject <NSCopying, NSMutableCopying, NSCoding>

@property NSString *server;
@property NSUInteger port;
@property BOOL usingSSL;
@property BOOL usingAuthorization;
@property NSString *username;
@property NSString *password;
@property NSString *realm;
@property NSString *rpcPath;

-(NSString *)protocol;
-(NSURL *)rpcURL;

@end
