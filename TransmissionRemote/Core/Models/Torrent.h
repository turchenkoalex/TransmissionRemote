//
//  Torrent.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 15.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TorrentState) {
    STATE_STOPPED        = 0, /* Torrent is stopped */
    STATE_CHECK_WAIT     = 1, /* Queued to check files */
    STATE_CHECK          = 2, /* Checking files */
    STATE_DOWNLOAD_WAIT  = 3, /* Queued to download */
    STATE_DOWNLOAD       = 4, /* Downloading */
    STATE_SEED_WAIT      = 5, /* Queued to seed */
    STATE_SEED           = 6  /* Seeding */
};

@interface Torrent : NSObject

@property NSInteger torrentId;
@property NSString *torrentName;
@property NSString *torrentComment;
@property TorrentState torrentState;
@property NSUInteger torrentDownloadPercent;
@property NSUInteger torrentVerifyPercent;
@property double uploadRatio;
@property NSUInteger totalSize;

@end
