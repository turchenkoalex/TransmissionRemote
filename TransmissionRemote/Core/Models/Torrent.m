//
//  Torrent.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 15.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "Torrent.h"

@implementation Torrent

-(void)applyChangesFromTorrent:(Torrent *)torrent {
    if (torrent) {
        if (self.status != torrent.status) self.status = torrent.status;
        if (self.percentDone != torrent.percentDone) self.percentDone = torrent.percentDone;
        if (self.recheckProgress != torrent.recheckProgress) self.recheckProgress = torrent.recheckProgress;
        if (self.uploadRatio != torrent.uploadRatio) self.uploadRatio = torrent.uploadRatio;
        if (self.rateDownload != torrent.rateDownload) self.rateDownload = torrent.rateDownload;
        if (self.rateUpload != torrent.rateUpload) self.rateUpload = torrent.rateUpload;
        if (self.leftUntilDone != torrent.leftUntilDone) self.leftUntilDone = torrent.leftUntilDone;
        if (self.fileStats != torrent.fileStats) self.fileStats = torrent.fileStats;
        if (self.eta != torrent.eta) self.eta = torrent.eta;
        if (self.peersConnected != torrent.peersConnected) self.peersConnected = torrent.peersConnected;
        if (self.queuePosition != torrent.queuePosition) self.queuePosition = torrent.queuePosition;
    }
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@", self.id];
}

@end
