//
//  MessageListView.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-14.
//
//

#import "BaseView.h"

@class MessageDTO;
@interface MessageListView : BaseView

@property (nonatomic, strong) KKAvatarView *userAvatar;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *messageLable;
@property (nonatomic, strong) UIView *unreadFlag;

@property (nonatomic, strong) MessageDTO *messageInfo;

- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

@end
