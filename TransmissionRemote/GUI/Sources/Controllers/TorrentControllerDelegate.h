//
//  TorrentControllerDelegate.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 11.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Torrent.h"

@protocol TorrentControllerDelegate <NSObject>

-(void)torrentControllerClose:(id)controller;

@end
