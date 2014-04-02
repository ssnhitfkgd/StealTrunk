//
//  NSBubbleData.m
//
//  Created by Alex Barinov
//  StexGroup, LLC
//  http://www.stexgroup.com
//
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "NSBubbleData.h"

@implementation NSBubbleData

@synthesize sendDate = _sendDate;
@synthesize sendType = _sendType;
@synthesize messageType = _messageType;
@synthesize messageData = _messageData;

+ (id)initWithData:(NSString *)data sendDate:(NSDate *)sendDate sendType:(NSBubbleSendType)sendType messageType:(NSBubbleMessageType)messageType
{
//    return [[NSBubbleData alloc] initWithText:data andDate:sendDate sendType:messageType messageType:messageType];
    
    return [[NSBubbleData alloc] initWithData:data sendDate:sendDate sendType:sendType messageType:messageType];
}

- (id)initWithData:(NSString *)data sendDate:(NSDate *)sendDate sendType:(NSBubbleSendType)initSendType messageType:(NSBubbleMessageType)initMessageType
{
    self = [super init];
    if (self)
    {
        _messageData = data;
        if (_messageData && [_messageData isKindOfClass:[NSNull class]])
            _messageData = @" ";
        
        _sendDate = sendDate;
        _sendType = initSendType;
        _messageType = initMessageType;
    }
    return self;
}


@end
