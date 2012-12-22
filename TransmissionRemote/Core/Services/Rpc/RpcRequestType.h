//
//  RpcRequestType.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 02.12.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#ifndef TransmissionRemote_RpcRequestType_h
#define TransmissionRemote_RpcRequestType_h

typedef NS_ENUM(NSUInteger, RpcRequestType) {
    REQUEST_SESSION_GET,
    REQUEST_SESSION_SET,
    REQUEST_TORRENT_INIT,
    REQUEST_TORRENT_UPDATE,
    REQUEST_TORRENT_FULLUPDATE,
    REQUEST_TORRENT_ADD,
    REQUEST_TORRENT_REMOVE,
    REQUEST_TORRENT_START,
    REQUEST_TORRENT_STOP,
    REQUEST_TORRENT_VERIFY,
    REQUEST_TORRENT_SET,
    REQUEST_TORRENT_LOCATION
};

#endif
