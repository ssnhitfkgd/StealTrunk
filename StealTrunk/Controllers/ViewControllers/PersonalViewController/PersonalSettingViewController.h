//
//  PersonalSettingViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-8-9.
//
//

#import "JMStaticContentTableViewController.h"
#import "SimpleTextViewController.h"

@protocol MaskAvatarCameraDelegate;

@interface PersonalSettingViewController : JMStaticContentTableViewController<UIAlertViewDelegate,MaskAvatarCameraDelegate,SimpleTextViewControllerDelegate>

@end
