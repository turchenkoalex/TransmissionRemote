//
//  TorrentItem+Viewable.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 25.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "TorrentItem.h"

@interface TorrentItem (Viewable)

@property (readonly)  BOOL isLeaf;

@property (readonly) NSString *humanizedItemSize;
@property (readonly) NSString *humanizedCompletedSize;

@end
