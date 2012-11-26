//
//  TorrentItem.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 25.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TorrentItem : NSObject

@property NSString *itemName;
@property NSUInteger itemSize;
@property NSUInteger completedSize;
@property BOOL enabled;
@property NSArray *childs;

@end
