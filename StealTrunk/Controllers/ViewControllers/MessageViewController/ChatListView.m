//
//  ChatListView.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-14.
//
//

#import "ChatListView.h"
#import "ChatDto.h"

#define MESSAGE_TYPE_TO_ME  1//发送给我
#define MESSAGE_TYPE_FROM_ME 2//我发送的

@implementation ChatListView
@synthesize chatInfo = _chatInfo;
@synthesize userAvatar = _userAvatar;
@synthesize userName = _userName;
@synthesize chatLabel = _chatLabel;
@synthesize chatFlagImageView = _chatFlagImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubview];
        
        self.clipsToBounds = YES;
        self.height = 70;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 70;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.chatInfo = [[ChatDto alloc] init];
        if([_chatInfo parse2:item])
        {
            NSURL *avatar_url = [NSURL URLWithString:_chatInfo.userInfo.avatar];
            if(avatar_url)
            {
                [_userAvatar setImageWithURL:avatar_url];
            }
            
            _userName.text = _chatInfo.userInfo.user_name;
            _chatLabel.text = _chatInfo.chatMessage.text;
#warning 私信 缺图
            _chatFlagImageView.image = [UIImage imageNamed:(_chatInfo.chatMessage.chat_type == MESSAGE_TYPE_FROM_ME)?@"":@""];
            
            if(_chatInfo.userInfo.user_id)
            {
                id msgCount = [[NSUserDefaults standardUserDefaults] objectForKey:_chatInfo.userInfo.user_id];
                if(msgCount && [msgCount integerValue] > 0)
                {
#warning 设置消息个数  或提示
                }
                else
                {
                }
                
            }

        }
    }
    
    [self setNeedsLayout];
}

- (void)createSubview
{
    self.userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [_userAvatar.layer setMasksToBounds:YES];
    [_userAvatar.layer setCornerRadius:25];

    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _userName.left = self.userAvatar.right + 10;
    _userName.top = self.userAvatar.top;
    [_userName setTextColor:RGB165];
    _userName.backgroundColor = [UIColor clearColor];
    
    self.chatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    _chatLabel.left = self.userAvatar.right + 10;
    _chatLabel.top = self.userName.bottom+10;
    _chatLabel.width = self.userName.width;
    [_userName setTextColor:RGB89];
    _userName.backgroundColor = [UIColor clearColor];
    
    self.chatFlagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    _chatFlagImageView.centerY = _chatLabel.centerY;
    _chatFlagImageView.backgroundColor = [UIColor redColor];
    
    [self addSubview:_userAvatar];
    [self addSubview:_userName];
    [self addSubview:_chatLabel];
    [self addSubview:_chatFlagImageView];
}

- (NSString*)getChatToUserID
{
    return self.chatInfo.userInfo.user_id;
}

- (NSString*)getChatToUserName
{
    return self.chatInfo.userInfo.user_name;
}
@end
