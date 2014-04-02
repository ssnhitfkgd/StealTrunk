//
//  MessageListView.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-14.
//
//

#import "MessageListView.h"
#import "MessageDTO.h"

@implementation MessageListView
@synthesize messageInfo = _messageInfo;
@synthesize userAvatar = _userAvatar;
@synthesize userName = _userName;
@synthesize messageLable = _messageLable;
@synthesize unreadFlag = _unreadFlag;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubview];
        
        self.clipsToBounds = YES;
        self.height = 70;
        self.backgroundColor = [UIColor brownColor];
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
        self.messageInfo = [[MessageDTO alloc] init];
        if([_messageInfo parse2:item])
        {
            [self.userAvatar setUserInfo:self.messageInfo.userInfo EnableTap:YES];
            
            self.userName.text = self.messageInfo.userInfo.user_name;
            self.messageLable.text = @"缺接口...";
            
            self.unreadFlag.hidden = self.messageInfo.is_readed;
        }
    }
    
    [self setNeedsLayout];
}

- (void)createSubview
{    
    self.userAvatar = [KKAvatarView creatWithSize:50];
    self.userAvatar.top = 10;
    self.userAvatar.left = 10;
    self.userAvatar.backgroundColor = [UIColor redColor];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.userName.left = self.userAvatar.right + 10;
    self.userName.top = self.userAvatar.top;
    self.userName.backgroundColor = [UIColor blueColor];
    
    self.messageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.messageLable.left = self.userName.left;
    self.messageLable.top = self.userName.bottom+10;
    self.messageLable.width = self.userName.width;
    self.messageLable.backgroundColor = [UIColor greenColor];
    
    self.unreadFlag = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.unreadFlag.right = 320;
    self.unreadFlag.backgroundColor = [UIColor redColor];
    
    [self addSubview:self.userAvatar];
    [self addSubview:self.userName];
    [self addSubview:self.messageLable];
    [self addSubview:self.unreadFlag];
}

@end
