//
//  RpcProtocolHandlerDelegate.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 21.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RpcProtocolHandlerDelegate <NSObject>

-(void)didRequestReceivedWithTag:(NSUInteger)aTag andData:(id)data;

@end
