//
//  NSBubbleData.h
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

#import <Foundation/Foundation.h>

typedef enum _NSBubbleSendType
{
    BubbleTypeMine = 2,
    BubbleTypeSomeoneElse = 1,
} NSBubbleSendType;

typedef enum _NSBubbleMessageType
{
    BubbleMessageTypeText = 1,
    BubbleMessageTypeAudio,
    BubbleMessageTypeImage,
} NSBubbleMessageType;

@interface NSBubbleData : NSObject

@property (readonly, nonatomic, strong) NSDate *sendDate;
@property (readonly, nonatomic) NSBubbleSendType sendType;
@property (readonly, nonatomic) NSBubbleMessageType messageType;

@property (readonly, nonatomic, strong) NSString *messageData;

+ (id)initWithData:(NSString *)data sendDate:(NSDate *)sendDate sendType:(NSBubbleSendType)sendType messageType:(NSBubbleMessageType)messageType;

- (id)initWithData:(NSString *)data sendDate:(NSDate *)sendDate sendType:(NSBubbleSendType)initSendType messageType:(NSBubbleMessageType)initMessageType;

@end
