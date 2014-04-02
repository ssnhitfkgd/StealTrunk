//
//  TempLauchView.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-10.
//
//

#import "TempLauchView.h"

#import "FriendsListViewController.h"
#import "FriendsNewsViewController.h"
#import "FriendsAddListViewController.h"
#import "BaseTabBarController.h"
#import "BaseTabBarItem.h"
#import "BaseNavigationViewController.h"

#import "NearbyPeopleViewController.h"
#import "NearbyTribeViewController.h"

#import "PublishViewController.h"

#import "GRAlertView.h"

#import "MessageListViewController.h"
#import "ChatListViewController.h"
#import "PersonalViewController.h"

#import "SettingViewController.h"

#import "MaskAvatarCamera.h"

#import "TaskListViewController.h"
#import "ScoreListViewController.h"

#import "AppDelegate.h"

@implementation TempLauchView
@synthesize handelSquaredBtn = _handelSquaredBtn;
@synthesize squaredView = _squaredView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (IBAction)handelSquaredBtnPress:(id)sender
{
    [UIView animateWithDuration:0.2f
                     animations:^{
                         if (self.handelSquaredBtn.selected) {
                             self.squaredView.bottom = self.height+self.squaredView.height;
                         }else {
                             self.squaredView.bottom = self.height;
                         }
                         
                         self.handelSquaredBtn.bottom = self.squaredView.top;
                         
                     } completion:^(BOOL finished) {
                         self.handelSquaredBtn.selected = !self.handelSquaredBtn.selected;
                     }];
}

- (IBAction)dismissSquaredBtnPress:(id)sender
{
    if (self.handelSquaredBtn.selected) {
        [self handelSquaredBtnPress:self.handelSquaredBtn];
    }
}

#pragma mark - 
//消息
- (IBAction)messageBtnPress:(id)sender
{
    BaseTabBarItem *tab1 = [BaseTabBarItem creatWithTabController:[[MessageListViewController alloc] init] SelectedImage:[UIImage imageNamed:@"tabbar_message_selected"]  UnselectedImage:[UIImage imageNamed:@"tabbar_message"]];
    BaseTabBarItem *tab2 = [BaseTabBarItem creatWithTabController:[[ChatListViewController alloc] init] SelectedImage:[UIImage imageNamed:@"tabbar_chat_selected"] UnselectedImage:[UIImage imageNamed:@"tabbar_chat"]];
    NSArray *tabArray = [NSArray arrayWithObjects:tab1,tab2, nil];
    
    BaseTabBarController *friendsTabController = [BaseTabBarController creatWithTabs:tabArray];
    
    [self.viewController presentViewController:friendsTabController animated:YES completion:^{ }];
    //dismiss lauch
    [self handelSquaredBtnPress:self.handelSquaredBtn];
}

//奖励
- (IBAction)rewardBtnPress:(id)sender
{
    BaseTabBarItem *tab1 = [BaseTabBarItem creatWithTabController:[[TaskListViewController alloc] init] SelectedImage:[UIImage imageNamed:@"tabbar_task_selected"]  UnselectedImage:[UIImage imageNamed:@"tabbar_task"]];
    BaseTabBarItem *tab2 = [BaseTabBarItem creatWithTabController:[[ScoreListViewController alloc] init] SelectedImage:[UIImage imageNamed:@"tabbar_score_selected"] UnselectedImage:[UIImage imageNamed:@"tabbar_score"]];
    NSArray *tabArray = [NSArray arrayWithObjects:tab1,tab2, nil];
    
    BaseTabBarController *friendsTabController = [BaseTabBarController creatWithTabs:tabArray];
    
    [self.viewController presentViewController:friendsTabController animated:YES completion:^{ }];
    //dismiss lauch
    [self handelSquaredBtnPress:self.handelSquaredBtn];
}

//排行榜
- (IBAction)rankBtnPress:(id)sender
{
    
    //dismiss lauch
    [self handelSquaredBtnPress:self.handelSquaredBtn];
}

//商店
- (IBAction)storeBtnPress:(id)sender
{
    
    //dismiss lauch
    [self handelSquaredBtnPress:self.handelSquaredBtn];
}

//仓库
- (IBAction)storageBtnPress:(id)sender
{
    
    //dismiss lauch
    [self handelSquaredBtnPress:self.handelSquaredBtn];
}

//装饰
- (IBAction)dressBtnPress:(id)sender
{
    
    //dismiss lauch
    [self handelSquaredBtnPress:self.handelSquaredBtn];
}

//我的空间
- (IBAction)myZoneBtnPress:(id)sender
{
    PersonalViewController *personalViewController = [[PersonalViewController alloc] initWithUserInfo:[[AccountDTO sharedInstance] monstea_user_info]];
    BaseNavigationViewController *postNavi = [BaseNavigationViewController creataWithRootViewController:personalViewController CustomBarImage:nil NeedDismiss:YES];
    [self.viewController presentViewController:postNavi animated:YES completion:^{ }];
    
    //dismiss lauch
    [self handelSquaredBtnPress:self.handelSquaredBtn];
}

//我的部落
- (IBAction)myTribeBtnPress:(id)sender
{
    
    //dismiss lauch
    [self handelSquaredBtnPress:self.handelSquaredBtn];
}

//设置
- (IBAction)settingBtnPress:(id)sender
{
    SettingViewController *settingVC = [[SettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    BaseNavigationViewController *settingNavi = [BaseNavigationViewController creataWithRootViewController:settingVC CustomBarImage:nil NeedDismiss:YES];
    [self.viewController presentViewController:settingNavi animated:YES completion:^{ }];
    
    //dismiss lauch
    [self handelSquaredBtnPress:self.handelSquaredBtn];
}

#pragma mark -

//好友
- (IBAction)friendsBtnPress:(id)sender
{
    BaseTabBarItem *tab1 = [BaseTabBarItem creatWithTabController:[[FriendsListViewController alloc] init] SelectedImage:[UIImage imageNamed:@"tabbar-friendRank-selected"] UnselectedImage:[UIImage imageNamed:@"tabbar-friendRank-normal"]];
    BaseTabBarItem *tab2 = [BaseTabBarItem creatWithTabController:[[FriendsNewsViewController alloc] init] SelectedImage:[UIImage imageNamed:@"tabbar-status-selected"] UnselectedImage:[UIImage imageNamed:@"tabbar-status-normal"]];
    BaseTabBarItem *tab3 = [BaseTabBarItem creatWithTabController:[[FriendsAddListViewController alloc] init] SelectedImage:[UIImage imageNamed:@"tabbar-addFriend-selected"] UnselectedImage:[UIImage imageNamed:@"tabbar-addFriend-normal"]];
    NSArray *tabArray = [NSArray arrayWithObjects:tab1,tab2,tab3, nil];
    
    BaseTabBarController *friendsTabController = [BaseTabBarController creatWithTabs:tabArray];
    
    [self.viewController presentViewController:friendsTabController animated:YES completion:^{ }];
}

//附近
- (IBAction)nearbyBtnPress:(id)sender
{
    BaseTabBarItem *tab1 = [BaseTabBarItem creatWithTabController:[[NearbyPeopleViewController alloc] init] SelectedImage:[UIImage imageNamed:@"near_people_selected"] UnselectedImage:[UIImage imageNamed:@"near_people"]];
    BaseTabBarItem *tab2 = [BaseTabBarItem creatWithTabController:[[NearbyTribeViewController alloc] init] SelectedImage:[UIImage imageNamed:@"near_farm_selected"] UnselectedImage:[UIImage imageNamed:@"near_farm"]];
    NSArray *tabArray = [NSArray arrayWithObjects:tab1,tab2, nil];
    
    BaseTabBarController *nearbyTabController = [BaseTabBarController creatWithTabs:tabArray];
    
    [self.viewController presentViewController:nearbyTabController animated:YES completion:^{ }];
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
     
    if (point.y > 400 || CGRectContainsPoint(self.squaredView.frame, point) || CGRectContainsPoint(self.handelSquaredBtn.frame, point)) {
        return TRUE;
    }
    if(self.handelSquaredBtn.selected)
    [self handelSquaredBtnPress:self.handelSquaredBtn];
    return FALSE;
}


@end
