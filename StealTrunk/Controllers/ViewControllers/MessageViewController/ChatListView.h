//
//  ChatListView.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-14.
//
//

#import "BaseView.h"

@class ChatDto;
@interface ChatListView : BaseView

@property (nonatomic, strong) UIImageView *userAvatar;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *chatLabel;
@property (nonatomic, strong) UIImageView *chatFlagImageView;


@property (nonatomic, strong) ChatDto *chatInfo;

- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;
- (NSString*)getChatToUserID;
- (NSString*)getChatToUserName;
@end
