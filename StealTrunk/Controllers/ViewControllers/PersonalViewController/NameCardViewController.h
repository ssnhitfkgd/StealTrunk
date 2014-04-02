//
//  NameCardViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-21.
//
//

#import "BaseController.h"
#import "UIViewController+MJPopupViewController.h"

@class NTParallaxStackController;
@interface CardView : UIView

@property (nonatomic, strong) UIView *photoWallView;
@property (nonatomic, strong) KKAvatarView *userAvatar;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIView *backMask;
@property (nonatomic, strong) NTParallaxStackController *parallaxSC;
@property (nonatomic, strong) Monstea_user_info *userInfo;
@property (nonatomic, strong) UIButton *settingBtn;


- (void)startDeviceMotion;
- (void)stopDeviceMotion;
- (void)settingBtnPress:(id)sender;

@end

///////////////////////////////////
@protocol NameCardViewControllerDelegate <NSObject>

@optional
- (void)pushToZoneWithUserInfo:(Monstea_user_info *)userInfo;
- (void)pushToFarmWithUserInfo:(Monstea_user_info *)userInfo;

@end


@interface NameCardViewController : BaseController<UIAlertViewDelegate>
@property (nonatomic, strong) CardView *cardView;
@property (nonatomic, strong) id<NameCardViewControllerDelegate>delegate;

+ (NameCardViewController *)creatWithUserID:(NSString *)user_id Popup:(BOOL)is_popup;

@end
