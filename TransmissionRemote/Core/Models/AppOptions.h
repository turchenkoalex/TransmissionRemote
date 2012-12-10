//
//  AppOptions.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 26.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppOptions : NSObject <NSCoding>

@property BOOL removeFilesAfterAddingTorrent;
@property BOOL removeTorrentWithLocalData;

@end
