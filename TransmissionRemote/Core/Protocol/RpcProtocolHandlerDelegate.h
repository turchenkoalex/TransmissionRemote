//
//  RpcProtocolHandlerDelegate.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 21.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerStatus.h"

@protocol RpcProtocolHandlerDelegate <NSObject>

-(void)didInitializeTorrentsRequestReceived:(NSArray *)torrents;
-(void)didUpdateTorrentsRequestReceived:(NSArray *)torrents;
-(void)didRemovedTorrentsRequestReceived:(NSArray *)torrents;
-(void)didFullUpdateTorrentsRequestReceived:(NSArray *)torrents;
-(void)didAddTorrentsRequestReceived:(NSUInteger)torrentId;
-(void)didSessionGetRequestReceived:(ServerStatus *)serverStatus;

@end
