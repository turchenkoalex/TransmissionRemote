//
//  TorrentParentedFile.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 09.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "TorrentFile.h"

@interface TorrentParentedFile : TorrentFile {
    NSArray *_childs;
}

@property (readonly) BOOL leaf;
@property (readonly) double completedPercent;
@property NSString *displayName;
@property NSArray  *childs;
@property NSString *index;

@end
