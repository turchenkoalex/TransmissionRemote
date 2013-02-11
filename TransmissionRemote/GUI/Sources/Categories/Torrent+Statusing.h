//
//  Torrent+Statusing.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 03.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "Torrent.h"

typedef NS_ENUM(NSUInteger, TorrentStatus) {
    STATUS_UNACTIVE = 0,
    STATUS_DOWNLOAD = 1,
    STATUS_SEED     = 2,
    STATUS_VERIFY   = 3,
    STATUS_ERROR    = 4
};

@interface Torrent (Statusing)

@property (readonly) TorrentStatus torrentStatus;
@property (readonly) NSString *statusName;
@property (readonly) NSImage *statusImage;
@property (readonly) NSString *statusInformation;
@property (readonly) NSColor *uploadRatioColor;

@end
