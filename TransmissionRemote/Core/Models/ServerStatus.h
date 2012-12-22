//
//  ServerStatus.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 19.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerStatus : NSObject

@property NSString *version;
@property BOOL connected;
@property BOOL speedLimit;
@property NSString *downloadDirectory;

@end
