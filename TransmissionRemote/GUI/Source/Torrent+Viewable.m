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

-(BOOL)isDownload {
    return (self.torrentState == STATE_DOWNLOAD);
}

+(NSSet *)keyPathsForValuesAffectingStatusImage {
    return [NSSet setWithObjects:@"torrentState", nil];
}

+(NSSet *)keyPathsForValuesAffectingTorrentComplete {
    return [NSSet setWithObjects:@"torrentDownloadPercent", @"torrentVerifyPercent", nil];
}

+(NSSet *)keyPathsForValuesAffectingIsDownload {
    return [NSSet setWithObjects:@"torrentState", nil];
}

@end
