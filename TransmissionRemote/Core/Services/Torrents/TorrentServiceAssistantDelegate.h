//
//  TorrentServiceAssistantDelegate.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerStatus.h"

@protocol TorrentServiceAssistantDelegate <NSObject>

-(void)torrentServiceAssistantDidInitializeTorrentsArray;
-(void)torrentServiceAssistantDidUpdateTorrentsArrayWithChange:(BOOL)changed;
-(void)torrentServiceAssistantDidFindNewTorrentsWithTorrentIdArray:(NSArray *)torrentIdArray;
-(void)torrentServiceAssistantDidUpdateServerStatus:(ServerStatus *)serverStatus;
-(void)torrentServiceAssistantDidRemoveTorrentsArray:(NSArray *)torrentsArray;
-(void)torrentServiceAssistantDidLoadTorrentsArray:(NSArray *)torrentsArray;
-(void)torrentServiceAssistantDidChangeTotalDownloadRate:(NSUInteger)downloadRate andUploadRate:(NSUInteger)uploadRate;
-(void)torrentServiceAssistantDidDownloadedTorrents:(NSArray *)torrentsArray;
-(void)torrentServiceAssistantDidCheckedTorrents:(NSArray *)torrentsArray;
-(void)torrentServiceAssistantDidChangeTorrent:(NSString *)torrentId;
-(void)torrentServiceAssistantDidChangeTorrents:(NSArray *)torrentIdArray;
-(void)torrentServiceAssistantDidAddTorrent:(id)torrentId;

@end
