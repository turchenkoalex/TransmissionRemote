//
//  TorrentFile.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 25.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TorrentFile : NSObject

@property NSString *name;
@property NSUInteger length;
@property BOOL wanted;
@property NSUInteger bytesCompleted;
@property NSUInteger priority;

@end
