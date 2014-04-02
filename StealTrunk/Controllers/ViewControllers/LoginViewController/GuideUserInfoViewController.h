//
//  GuideUserInfoViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-21.
//
//

#import "BaseController.h"
#import "AKSegmentedControl.h"
#import "GRAlertView.h"

@interface GuideUserInfoViewController : BaseController<UITextFieldDelegate,AKSegmentedControlDelegate>

@property (nonatomic, strong) UIImageView *userAvatar;
@property (nonatomic, strong) UITextField *userName;
@property (nonatomic, strong) UIButton *birthdayBtn;
@property (nonatomic, strong) UIView *birthdayPickView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) AKSegmentedControl *genderSeg;
@property (nonatomic, strong) UIButton *nextStep;

@property (nonatomic, strong) Monstea_user_info *userInfo;

- (void)birthdayBtnPress:(id)sender;
- (void)nextStepBtnPress:(id)sender;

@end
