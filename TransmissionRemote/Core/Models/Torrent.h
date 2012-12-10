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

@property id          id;                // ID
@property NSString    *name;              // Name
@property NSString    *downloadDir;       // Download Directory
@property NSInteger    eta;               // Downlaod Time Remaing
@property NSString    *comment;           // URL on torrent page
@property TorrentState status;            // Status
@property double       percentDone;       // Verify complete percentage
@property double       recheckProgress;   // Download complete percentage
@property NSUInteger   totalSize;         // Size of all files
@property NSUInteger   queuePosition;     // Position
@property NSString    *torrentFile;       // Torrent File Name
@property double       uploadRatio;       // Ratio
@property NSUInteger   rateDownload;      // Speed of downlaod
@property NSUInteger   rateUpload;        // Speed of upload
@property NSUInteger   leftUntilDone;     // Size of content for download
@property NSUInteger   bandwidthPriority; // Priority
@property NSInteger    error;             // Error code
@property NSString    *errorString;       // Error message
@property NSArray     *files;             // Files (name, length, bytesCompleted)
@property NSArray     *fileStats;         // Stat of files (bytesCompleted, wanted, priority)
@property NSUInteger   peersConnected;    //

-(void)applyChangesFromTorrent:(Torrent *)torrent;

@end
