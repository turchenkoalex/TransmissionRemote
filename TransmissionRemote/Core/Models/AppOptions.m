//
//  AppOptions.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 26.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "AppOptions.h"

@implementation AppOptions

#pragma mark - <NSCoding>

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [[[self class] alloc] init];
    if (self) {
        _removeFilesAfterAddingTorrent = [aDecoder decodeBoolForKey:@"removeFilesAfterAddingTorrent"];
        _removeTorrentWithLocalData = [aDecoder decodeBoolForKey:@"removeTorrentWithLocalData"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:_removeFilesAfterAddingTorrent forKey:@"removeFilesAfterAddingTorrent"];
    [aCoder encodeBool:_removeTorrentWithLocalData forKey:@"removeTorrentWithLocalData"];
}

@end
