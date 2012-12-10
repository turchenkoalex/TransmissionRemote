//
//  NSTimeRemainFormatter.h
//  TransmissionRemote
//
//  Created by Александр Турченко on 28.11.12.
//  Copyright (c) 2012 TurchenkoAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimeRemainFormatter : NSFormatter {
    NSCalendar *systemCalendar;
    NSDate *originDate;
    unsigned int unitFlags;
    NSNumberFormatter *numberFormatter;
}

@end
