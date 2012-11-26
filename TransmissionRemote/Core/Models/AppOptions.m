//
//  AppOptions.m
//  TransmissionRemote
//
//  Created by Александр Турченко on 26.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import "AppOptions.h"

@implementation AppOptions

-(void)apply:(AppOptions *)fromOptions {
    self.removeFilesAfterAdd = fromOptions.removeFilesAfterAdd;
    self.removeDataWithTorrent = fromOptions.removeDataWithTorrent;
}

#pragma mark - <NSCopying>

-(id)copyWithZone:(NSZone *)zone {
    AppOptions *copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        [copy apply:self];
    }
    return copy;
}

#pragma mark - <NSMutableCopying>

-(id)mutableCopyWithZone:(NSZone *)zone {
    AppOptions *copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        [copy apply:self];
    }
    return copy;
}

#pragma mark - <NSCoding>

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [[[self class] alloc] init];
    if (self) {
        _removeFilesAfterAdd = [aDecoder decodeBoolForKey:@"removeFilesAfterAdd"];
        _removeDataWithTorrent = [aDecoder decodeBoolForKey:@"removeDataWithTorrent"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:_removeFilesAfterAdd forKey:@"removeFilesAfterAdd"];
    [aCoder encodeBool:_removeDataWithTorrent forKey:@"removeDataWithTorrent"];
}


@end
