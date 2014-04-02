//
//  NearbyPeopleView.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-16.
//
//

#import "NearbyPeopleView.h"

@implementation NearbyPeopleView

@synthesize userAvatar = _userAvatar;
@synthesize userName = _userName;
@synthesize userSign = _userSign;
@synthesize loginInfo = _loginInfo;
@synthesize sexButton = _sexButton;
@synthesize thiefIcon = _thiefIcon;
@synthesize wormIcon = _wormIcon;
@synthesize userInfo = _userInfo;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self createSubview];
        
        self.clipsToBounds = YES;
        self.height = 80;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.userInfo = [[Monstea_user_info alloc] init];
        [self.userInfo parseWithDic:item];
        
        [self.userAvatar setUserInfo:self.userInfo EnableTap:YES];
        
        self.userName.text = self.userInfo.user_name;
        
        NSString *gender;
        switch (self.userInfo.gender) {
            case 0:
            {
                gender = NSLocalizedString(@"未", nil);
                [_sexButton setImage:[UIImage imageNamed:@"icon-male"] forState:UIControlStateNormal];
                [_sexButton setBackgroundColor:[UIColor colorWithRed:243./255. green:98./255. blue:90./255. alpha:1.0]];

            }
                break;
            case 1:
            {
                gender = NSLocalizedString(@"男", nil);
                [_sexButton setBackgroundColor:[UIColor colorWithRed:62./255. green:204./255. blue:203./255. alpha:1.0]];

                [_sexButton setImage:[UIImage imageNamed:@"icon-male"] forState:UIControlStateNormal];

            }
                break;
            case 2:
            {
                [_sexButton setBackgroundColor:[UIColor colorWithRed:243./255. green:98./255. blue:90./255. alpha:1.0]];
                [_sexButton setImage:[UIImage imageNamed:@"icon-female"] forState:UIControlStateNormal];
                gender = NSLocalizedString(@"女", nil);
            }
                break;
            default:
                break;
        }
        
        [_sexButton setTitle:[NSString stringWithFormat:@"%d",self.userInfo.age] forState:UIControlStateNormal];
        
        NSString *distance = [NSString stringWithFormat:@"%.2fkm",[self.userInfo.distance floatValue]/1000];
        NSString *time = [NSDate easyGetDisplayTime:self.userInfo.login_time];
        
        self.loginInfo.text = [NSString stringWithFormat:@" %@-%@",distance,time,nil];
        self.userSign.text = self.userInfo.user_sign;
    }

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    if(self.userInfo.user_sign && [self.userInfo.user_sign isKindOfClass:[NSString class]] && [self.userInfo.user_sign isEqualToString:@""])
    {
        [_userSign removeFromSuperview];
        [self setHeight:60];
        _userName.top = _userAvatar.top + 10;
        _sexButton.top = _userName.bottom + 10;
        _loginInfo.top  = _userName.bottom + 10;
        
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        NSString *str = [item objectForKey:@"sign_text"];
        if(str && [str isKindOfClass:[NSNull class]])
        {
            return 70;
        }
        if(str && [str isEqualToString:@""])
        {
            return 70;
        }
    }
    return 80;
}

- (void)createSubview
{
    self.userAvatar = [KKAvatarView creatWithSize:50];
    _userAvatar.top = 10;
    _userAvatar.left = 10;
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 15)];
    _userName.top = _userAvatar.top;
    _userName.left = _userAvatar.right + 10;
    [_userName setFont:[UIFont systemFontOfSize:14]];
    [_userName setBackgroundColor:[UIColor clearColor]];
    [_userName setTextColor:RGB89];
    
    self.sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sexButton setWidth:40];
    [_sexButton setHeight:12];
    [_sexButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    _sexButton.top = _userName.bottom + 10;
    _sexButton.left = _userName.left;
    [_sexButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [_sexButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.loginInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 15)];
    _loginInfo.top = _userName.bottom + 10;
    _loginInfo.left = _sexButton.right;
    [_loginInfo setFont:[UIFont systemFontOfSize:10]];
    [_loginInfo setBackgroundColor:[UIColor clearColor]];
    [_loginInfo setTextColor:RGB(165,169,170)];
    
    
    self.userSign = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 15)];
    [_userSign setFont:[UIFont systemFontOfSize:14]];
    _userSign.top = _sexButton.bottom + 10;
    _userSign.left = _sexButton.left;
    [_userSign setLineBreakMode:NSLineBreakByTruncatingTail];
    [_userSign setNumberOfLines:1];
    [_userSign setBackgroundColor:[UIColor clearColor]];
    [_userSign setTextColor:RGB165];
    
    
    self.thiefIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-thief"]];
    _thiefIcon.frame = CGRectMake(0, 0, 27, 27);
    _thiefIcon.centerY = _userAvatar.centerY;
    _thiefIcon.right = self.width-10;
    
    self.wormIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-worm"]];
    _wormIcon.frame = CGRectMake(0, 0, 27, 27);
    _wormIcon.top = self.thiefIcon.top;
    _wormIcon.right = self.thiefIcon.right-self.thiefIcon.width-5;
    
    [self addSubview:_thiefIcon];
    [self addSubview:_wormIcon];
    [self addSubview:_sexButton];
    [self addSubview:_userAvatar];
    [self addSubview:_userName];
    [self addSubview:_loginInfo];
    [self addSubview:_userSign];
}

@end
