//
//  NearbyPeopleView.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-16.
//
//

#import "BaseView.h"

@interface NearbyPeopleView : BaseView

@property (nonatomic, strong) KKAvatarView *userAvatar;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userSign;
@property (nonatomic, strong) UILabel *loginInfo;
@property (nonatomic, strong) UIButton *sexButton;
@property (nonatomic, strong) Monstea_user_info *userInfo;
@property (nonatomic, strong) UIImageView *thiefIcon;
@property (nonatomic, strong) UIImageView *wormIcon;


- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

@end
