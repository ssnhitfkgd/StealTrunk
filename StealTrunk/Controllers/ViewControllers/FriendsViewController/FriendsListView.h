//
//  FriendsListView.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "BaseView.h"

@interface FriendsListView : BaseView

@property (nonatomic, strong) KKAvatarView *user_avatar;
@property (nonatomic, strong) UILabel *user_name;
@property (nonatomic, strong) UILabel *rank;
@property (nonatomic, strong) UILabel *gift_count;
@property (nonatomic, strong) UILabel *grade;

@property (nonatomic, strong) UIImageView *wormIcon;
@property (nonatomic, strong) UIImageView *thiefIcon;

@property(nonatomic, strong) Monstea_user_info *userInfo;

- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

- (void)tapAvatar;

@end
