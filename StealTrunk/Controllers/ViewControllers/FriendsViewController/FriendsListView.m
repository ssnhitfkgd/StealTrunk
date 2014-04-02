//
//  FriendsListView.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "FriendsListView.h"
#import "NameCardViewController.h"

@implementation FriendsListView

@synthesize user_avatar = _user_avatar;
@synthesize user_name = _user_name;
@synthesize rank = _rank;
@synthesize gift_count = _gift_count;
@synthesize grade = _grade;
@synthesize wormIcon = _wormIcon;
@synthesize thiefIcon = _thiefIcon;

@synthesize userInfo = _userInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.clipsToBounds = YES;
        self.height = 71;
        self.backgroundColor = [UIColor whiteColor];
        
        [self createSubview];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 71;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.userInfo = [[Monstea_user_info alloc] init];
        [self.userInfo parseWithDic:item];
        
        [self.user_avatar setUserInfo:self.userInfo EnableTap:YES];
            
        self.user_name.text = self.userInfo.user_name;
        
        self.rank.text = @"1";//4test
        self.grade.text = @"10";//4test
        self.thiefIcon.hidden = NO;//4test
        self.wormIcon.hidden = NO;//4test
        self.gift_count.text = @"10";//4test
        
        if (self.thiefIcon.hidden) {
            self.wormIcon.right = self.thiefIcon.right;
        }else {
            self.wormIcon.right = self.thiefIcon.right-self.thiefIcon.width-5;
        }
        
    }
    
    [self setNeedsLayout];
}

- (void)createSubview
{
    self.rank = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 70)];
    self.rank.backgroundColor = BenRed;
    self.rank.font = [UIFont systemFontOfSize:24];
    self.rank.textColor = [UIColor whiteColor];
    self.rank.textAlignment = UITextAlignmentCenter;
    
    self.user_avatar = [KKAvatarView creatWithSize:50];
    self.user_avatar.left = self.rank.right + 10;
    self.user_avatar.centerY = self.rank.centerY;
    
    UIImageView *gradeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-grade"]];
    gradeIcon.frame = CGRectMake(0, 0, 22, 22);
    gradeIcon.left = self.user_avatar.left-5;
    gradeIcon.bottom = self.user_avatar.bottom-2;
    self.grade = [[UILabel alloc] initWithFrame:gradeIcon.bounds];
    self.grade.backgroundColor = [UIColor clearColor];
    self.grade.font = [UIFont systemFontOfSize:10.0];
    self.grade.textColor = [UIColor whiteColor];
    self.grade.textAlignment = UITextAlignmentCenter;
    [gradeIcon addSubview:self.grade];
    
    self.user_name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    self.user_name.left = self.user_avatar.right + 10;
    self.user_name.top = self.user_avatar.top+3;
    self.user_name.font = [UIFont systemFontOfSize:16.0f];
    self.user_name.textColor = RGB89;
    self.user_name.backgroundColor = [UIColor clearColor];
    
    UIImageView *giftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-gift"]];
    giftIcon.contentMode = UIViewContentModeCenter;
    giftIcon.frame = CGRectMake(0, 0, 15, 20);
    giftIcon.left = self.user_name.left;
    giftIcon.top = self.user_name.bottom+5;
    
    self.gift_count = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.gift_count.left = giftIcon.right+3;
    self.gift_count.top = giftIcon.top+1;
    self.gift_count.width = 100;
    self.gift_count.font = [UIFont systemFontOfSize:14.0f];
    self.gift_count.textColor = RGB165;
    self.gift_count.backgroundColor = [UIColor clearColor];
    
    self.thiefIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-thief"]];
    self.thiefIcon.frame = CGRectMake(0, 0, 27, 27);
    self.thiefIcon.centerY = self.height/2.0;
    self.thiefIcon.right = self.width-10;
    self.thiefIcon.hidden = YES;
    
    self.wormIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-worm"]];
    self.wormIcon.frame = CGRectMake(0, 0, 27, 27);
    self.wormIcon.top = self.thiefIcon.top;
    self.wormIcon.right = self.thiefIcon.right-self.thiefIcon.width-5;
    self.wormIcon.hidden = YES;
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    separator.backgroundColor = RGB240;
    separator.bottom = self.height;
    
    [self addSubview:self.rank];
    [self addSubview:self.user_avatar];
    [self addSubview:gradeIcon];
    [self addSubview:self.user_name];
    [self addSubview:giftIcon];
    [self addSubview:self.gift_count];
    [self addSubview:self.thiefIcon];
    [self addSubview:self.wormIcon];
    
    [self addSubview:separator];
}


@end
