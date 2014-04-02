//
//  KKView.m
//  StealTrunk
//
//  Created by 点兄 on 13-8-8.
//
//

#import "KKView.h"
#import "StampDTO.h"
#import "NameCardViewController.h"
#import "PersonalViewController.h"

@interface KKAvatarView ()

@property (nonatomic, strong) Monstea_user_info *userDTO;
@property (nonatomic, strong) UIImageView *maskIV;
@property (nonatomic, strong) UIImageView *avatarIV;

@property (nonatomic, strong) UIImageView *stampIV;

@end

@implementation KKAvatarView
@synthesize userDTO = _userDTO;
@synthesize maskIV = _maskIV;
@synthesize avatarIV = _avatarIV;
@synthesize stampIV = _stampIV;

@synthesize stampDTO = _stampDTO;

+ (KKAvatarView *)creatWithSize:(NSInteger)size
{
    KKAvatarView *avatar = [[KKAvatarView alloc] init];
    
    avatar.frame = CGRectMake(0, 0, size, size);
    avatar.backgroundColor = [UIColor clearColor];
    
    avatar.avatarIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    avatar.avatarIV.layer.cornerRadius = size/2.0;
    avatar.avatarIV.clipsToBounds = YES;
    avatar.avatarIV.backgroundColor = [UIColor lightGrayColor];
    
    avatar.maskIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    avatar.stampIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];//??
    avatar.stampIV.backgroundColor = [UIColor lightGrayColor];
    avatar.stampIV.hidden = YES;
    
    [avatar addSubview:avatar.avatarIV];
    [avatar addSubview:avatar.maskIV];
    [avatar addSubview:avatar.stampIV];
    
    return avatar;
}

- (void)setUserInfo:(Monstea_user_info *)userInfo EnableTap:(BOOL)enable
{
    self.userDTO = userInfo;
    
    [self.avatarIV setImageWithURL:[NSURL URLWithString:[self.userDTO.avatar stringByAppendingFormat:@"/%fx%f",self.width*2,self.width*2]] placeholderImage:nil];
    
    if (enable) {
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar)];
        [self addGestureRecognizer:tapGes];
    }
}

- (void)setStampInfo:(StampDTO *)stampDTO
{
    if (stampDTO) {
        self.stampDTO = stampDTO;
        
        [self setUserInfo:stampDTO.userInfo EnableTap:YES];
        
        self.stampIV.hidden = NO;
        [self.stampIV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_write_sticker_big%@",stampDTO.like_type]]];
    }
}

- (void)tapAvatar
{
    NameCardViewController *NC = [NameCardViewController creatWithUserID:self.userDTO.user_id Popup:YES];
    NC.delegate = self;
    [self.viewController presentPopupViewController:NC animationType:MJPopupViewAnimationSlideTopBottom];
}

#pragma mark - Delegates
-(void)pushToZoneWithUserInfo:(Monstea_user_info *)userInfo
{
    [self.viewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
    
    PersonalViewController *personalVC = [[PersonalViewController alloc] initWithUserInfo:self.userDTO];
    [self.viewController.navigationController pushViewController:personalVC animated:YES];
}

-(void)pushToFarmWithUserInfo:(Monstea_user_info *)userInfo
{
    [self.viewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];    
}

@end
