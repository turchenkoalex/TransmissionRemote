//
//  Torrent+Viewable.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 16.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "Torrent.h"

static const NSString* TorrentStatusImageNames[] = {
    @"RedDot"    , /* Torrent is stopped */
    @"YellowDot" , /* Queued to check files */
    @"PurpleDot" , /* Checking files */
    @"YellowDot" , /* Queued to download */
    @"BlueDot"   , /* Downloading */
    @"YellowDot" , /* Queued to seed */
    @"GreenDot"    /* Seeding */
};

@interface Torrent (Viewable)

@property (readonly) NSString *torrentIdString;
@property (readonly) NSImage *statusImage;
@property (readonly) double torrentComplete;
@property (readonly) BOOL isActive;
@property (readonly) BOOL isDownloading;
@property (readonly) BOOL isWaiting;
@property (readonly) BOOL isStopped;
@property (readonly) BOOL isSeeding;
@property (readonly) BOOL isVerifing;
@property (readonly) NSArray *files;
@property (readonly) double estimatedTime;

@end
