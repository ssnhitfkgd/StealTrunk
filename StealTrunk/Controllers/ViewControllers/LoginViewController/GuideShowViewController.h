//
//  GuideShowViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-21.
//
//

#import "BaseController.h"

@interface GuideShowViewController : BaseController
@property (nonatomic, strong) Monstea_user_info *userInfo;

+ (GuideShowViewController *)creatWithUserInfo:(Monstea_user_info *)userInfo;

@end
