//
//  AppOptions.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 26.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppOptions : NSObject <NSCopying, NSMutableCopying, NSCoding>

@property BOOL removeFilesAfterAdd;
@property BOOL removeDataWithTorrent;

-(void)apply:(AppOptions *)fromOptions;

@end
