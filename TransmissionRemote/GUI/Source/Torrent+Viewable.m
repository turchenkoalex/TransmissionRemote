//
//  Torrent+Viewable.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 16.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "Torrent+Viewable.h"

@implementation Torrent (Viewable)

-(NSImage *)statusImage {
    return [NSImage imageNamed:[TorrentStatusImageNames[self.torrentState] copy]];
}

-(NSUInteger)torrentComplete {
    if (self.torrentState == STATE_CHECK_WAIT || self.torrentState == STATE_CHECK) {
        return self.torrentVerifyPercent;
    } else {
        return self.torrentDownloadPercent;
    }
}

#pragma mark - State properties

-(BOOL)isDownloading {
    return (self.torrentState == STATE_DOWNLOAD);
}

-(BOOL)isSeeding {
    return (self.torrentState == STATE_SEED);
}

-(BOOL)isStopping {
    return (self.torrentState == STATE_STOPPED);
}

-(BOOL)isVerifing {
    return (self.torrentState == STATE_CHECK);
}

-(BOOL)isWaiting {
    return (self.torrentState == STATE_CHECK_WAIT || self.torrentState == STATE_SEED_WAIT || self.torrentState == STATE_DOWNLOAD_WAIT);
}

#pragma mark - KeyPathes

+(NSSet *)keyPathsForValuesAffectingStatusImage {
    return [NSSet setWithObjects:@"torrentState", nil];
}

+(NSSet *)keyPathsForValuesAffectingTorrentComplete {
    return [NSSet setWithObjects:@"torrentDownloadPercent", @"torrentVerifyPercent", nil];
}

+(NSSet *)keyPathsForValuesAffectingIsSeeding {
    return [NSSet setWithObjects:@"torrentState", nil];
}

+(NSSet *)keyPathsForValuesAffectingIsStopping {
    return [NSSet setWithObjects:@"torrentState", nil];
}

+(NSSet *)keyPathsForValuesAffectingIsVerifing {
    return [NSSet setWithObjects:@"torrentState", nil];
}

+(NSSet *)keyPathsForValuesAffectingIsWaiting {
    return [NSSet setWithObjects:@"torrentState", nil];
}

@end
