//
//  BaseTabBarItem.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "BaseTabBarItem.h"
#import "BaseNavigationViewController.h"

@implementation BaseTabBarItem

@synthesize tabController = _tabController;
@synthesize tabTitle = _tabTitle;
@synthesize selectedImage = _selectedImage;
@synthesize unselectedImage = _unselectedImage;

+ (BaseTabBarItem *)creatWithTabController:(UIViewController *)tabController SelectedImage:(UIImage *)selectedImage UnselectedImage:(UIImage *)unselectedImage
{
    BaseTabBarItem *tabItem = [[BaseTabBarItem alloc] init];
    
    BaseNavigationViewController *navi = [BaseNavigationViewController creataWithRootViewController:tabController CustomBarImage:nil NeedDismiss:YES];
    
    tabItem.tabController = navi;
    tabItem.tabTitle = tabController.title;
    tabItem.selectedImage = selectedImage;
    tabItem.unselectedImage = unselectedImage;
    
    return tabItem;
}

@end
