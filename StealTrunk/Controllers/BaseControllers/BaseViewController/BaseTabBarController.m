//
//  BaseTabBarController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "BaseTabBarController.h"
#import "BaseTabBarItem.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
+ (BaseTabBarController *)creatWithTabs:(NSArray *)tabArray
{
    BaseTabBarController *tabController = [[BaseTabBarController alloc] init];
    
    [tabController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"emptyIMG"]];
    
    NSMutableArray *realViewControllers = [NSMutableArray array];
    for (BaseTabBarItem *tabItem in tabArray) {
        [realViewControllers addObject:tabItem.tabController];
    }

    tabController.viewControllers = realViewControllers;
    
    for (int i = 0; i < [realViewControllers count]; i++) {
        UITabBarItem *tabItem = [tabController.tabBar.items objectAtIndex:i];
        UIViewController *tabViewController = [realViewControllers objectAtIndex:i];
        BaseTabBarItem *baseTabItem = [tabArray objectAtIndex:i];

        tabItem.title = tabViewController.title;
        [tabItem setFinishedSelectedImage:baseTabItem.selectedImage withFinishedUnselectedImage:baseTabItem.unselectedImage];
    }
    

    return tabController;
}

@end
