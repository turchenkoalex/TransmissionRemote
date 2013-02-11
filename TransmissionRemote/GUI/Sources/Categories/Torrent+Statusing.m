//
//  Torrent+Statusing.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 03.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "Torrent+Statusing.h"
#import "NSByteSpeedFormatter.h"

static const NSString* TorrentStatusNames[] = {
    @"Unactive",
    @"Downloading",
    @"Seeding",
    @"Verifing",
    @"Stopped",
    @"Error"
};

static const NSString* TorrentStatusImages[] = {
    @"GrayDot",
    @"BlueDot",
    @"GreenDot",
    @"YellowDot",
    @"RedDot"
};

@implementation Torrent (Statusing)

-(TorrentStatus)torrentStatus {
    switch (self.status) {
        case STATE_DOWNLOAD:
            return STATUS_DOWNLOAD;
        case STATE_SEED:
            return STATUS_SEED;
        case STATE_CHECK:
            return STATUS_VERIFY;
        case STATE_STOPPED:
        case STATE_CHECK_WAIT:
        case STATE_SEED_WAIT:
        case STATE_DOWNLOAD_WAIT:
            return STATUS_UNACTIVE;
            
        default:
            return STATUS_ERROR;
    }
}

-(NSString *)statusName {
    return NSLocalizedString([TorrentStatusNames[self.torrentStatus] copy], "Status");;
}

-(NSImage *)statusImage {
    return [NSImage imageNamed:[TorrentStatusImages[self.torrentStatus] copy]];
}

-(NSString *)statusInformation {
    if (self.torrentStatus == STATUS_VERIFY) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        return [NSString stringWithFormat:@"%ld. %@: %@", self.queuePosition + 1, self.statusName, [formatter stringFromNumber:[NSNumber numberWithDouble:self.recheckProgress]]];
    } else if (self.torrentStatus == STATUS_UNACTIVE) {
        return [NSString stringWithFormat:@"%ld. %@", self.queuePosition + 1, self.statusName];
    } else {
        NSByteSpeedFormatter *formatter = [[NSByteSpeedFormatter alloc] init];
        [formatter setAllowsNonnumericFormatting:NO];
        [formatter setCountStyle:NSByteCountFormatterCountStyleBinary];
        
        return [NSString stringWithFormat:@"%ld. %@: ↓ %@, ↑ %@, %@ %ld", self.queuePosition + 1, self.statusName, [formatter stringFromByteCount:self.rateDownload], [formatter stringFromByteCount:self.rateUpload], NSLocalizedString(@"Peers", "Peers"), self.peersConnected];
    }
}

-(NSColor *)uploadRatioColor {
    if ([self uploadRatio] < 1.0) {
        return [NSColor redColor];
    } else {
        return [NSColor grayColor];
    }
}

#pragma mark - Observed KeyPathes

+(NSSet *)keyPathsForValuesAffectingTorrentStatus {
    return [NSSet setWithObjects:@"status", nil];
}

+(NSSet *)keyPathsForValuesAffectingStatusImage {
    return [NSSet setWithObjects:@"torrentStatus", nil];
}

+(NSSet *)keyPathsForValuesAffectingStatusName {
    return [NSSet setWithObjects:@"torrentStatus", nil];
}

+(NSSet *)keyPathsForValuesAffectingStatusInformation {
    return [NSSet setWithObjects:@"torrentStatus", @"queuePosition", @"rateDownload", @"rateUpload", @"peersConnected", nil];
}

+(NSSet *)keyPathsForValuesAffectingUploadRatioColor {
    return [NSSet setWithObjects:@"uploadRatio", nil];
}

@end
