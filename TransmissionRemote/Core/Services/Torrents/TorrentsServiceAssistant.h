//
//  TorrentsServiceAssistant.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcProtocolDelegate.h"
#import "TorrentServiceAssistantDelegate.h"


typedef NS_ENUM(NSUInteger, TorrentChangeObservingMask) {
    TorrentChangeObservingNoneMask     = 0,
    TorrentChangeObservingStatusMask   = 1 << 1
};


@interface TorrentsServiceAssistant : NSObject <RpcProtocolDelegate> {
    NSMutableDictionary *_torrentsDictionary;
    id <TorrentServiceAssistantDelegate> _delegate;
}

@property NSMutableArray *torrentsArray;
@property TorrentChangeObservingMask torrentChangeObservingMask;

-(id)initWithDelegate:(id <TorrentServiceAssistantDelegate>)aDelegate;
-(void)removeAllTorrents;

@end
