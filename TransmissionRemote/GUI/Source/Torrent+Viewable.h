//
//  Torrent+Viewable.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 16.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "Torrent.h"

static const NSString* TorrentStatusImageNames[] = {@"YellowDot",@"PurpleDot",@"PurpleDot",@"BlueDot",@"BlueDot",@"GreenDot",@"GreenDot"};


@interface Torrent (Viewable)

@property (readonly) NSImage *statusImage;
@property (readonly) NSUInteger torrentComplete;
@property (readonly) BOOL isDownload;

@end
