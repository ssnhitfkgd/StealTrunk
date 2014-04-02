//
//  BaseNavigationViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "BaseNavigationViewController.h"
#import "TableApiViewController.h"

@interface BaseNavigationViewController ()

@property (nonatomic,assign) BOOL needDismiss;

- (void)dismissBtnPress:(id)sender;

@end

@implementation BaseNavigationViewController
@synthesize needDismiss = _needDismiss;

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
+ (BaseNavigationViewController *)creataWithRootViewController:(UIViewController *)rootViewController CustomBarImage:(UIImage *)barImage NeedDismiss:(BOOL)needDismiss
{
    BaseNavigationViewController *baseNavi = [[BaseNavigationViewController alloc] init];
    baseNavi.delegate=baseNavi;
    
    baseNavi = [baseNavi initWithRootViewController:rootViewController];
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0, 0, 240, 44);
    titleBtn.backgroundColor = [UIColor clearColor];
    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleBtn.titleLabel.textAlignment = UITextAlignmentCenter;
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleBtn setTitle:rootViewController.title forState:UIControlStateNormal];
    titleBtn.showsTouchWhenHighlighted = YES;
    [titleBtn addTarget:baseNavi action:@selector(titleBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    baseNavi.visibleViewController.navigationItem.titleView = titleBtn;
    baseNavi.title = titleBtn.titleLabel.text;
    
    if (barImage) {
        [baseNavi.navigationBar setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
    }
    
    baseNavi.needDismiss = needDismiss;

    return baseNavi;
}

- (void)setNeedDismiss:(BOOL)needDismiss
{
    _needDismiss = needDismiss;
    if (_needDismiss) {
        UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dismissBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [dismissBtn setImage:[UIImage imageNamed:@"navi-btn-close"] forState:UIControlStateNormal];
        dismissBtn.frame = CGRectMake(0, 0, 50, 29);
        [dismissBtn addTarget:self
                       action:@selector(dismissBtnPress:)
             forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithCustomView:dismissBtn];
        UIViewController *rootVC = [self.viewControllers objectAtIndex:0];
        rootVC.navigationItem.leftBarButtonItem = dismissItem;
        
        if (!rootVC.navigationItem.rightBarButtonItem) {
            UIBarButtonItem *emptyItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:dismissBtn.frame]];
            rootVC.navigationItem.rightBarButtonItem = emptyItem;
        }
    }
}

- (void)dismissBtnPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)titleBtnPress:(id)sender{
    
    if ([self.visibleViewController isKindOfClass:[TableApiViewController class]]) {
        [[(TableApiViewController *)self.visibleViewController tableView] scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

- (void)popBack{
    
    [self popViewControllerAnimated:YES];
}


#pragma mark - Delegates
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != [navigationController.viewControllers objectAtIndex:0]) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [backBtn setImage:[UIImage imageNamed:@"navi-btn-back"] forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(0, 0, 50, 29);
        [backBtn addTarget:navigationController
                       action:@selector(popBack)
             forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        viewController.navigationItem.leftBarButtonItem = backItem;
    
        if (!viewController.navigationItem.rightBarButtonItem) {
            UIBarButtonItem *emptyItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:backBtn.frame]];
            viewController.navigationItem.rightBarButtonItem = emptyItem;
        }
        
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(0, 0, 240, 44);
        titleBtn.backgroundColor = [UIColor clearColor];
        titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        titleBtn.titleLabel.textAlignment = UITextAlignmentCenter;
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleBtn setTitle:viewController.title forState:UIControlStateNormal];
        titleBtn.showsTouchWhenHighlighted = YES;
        [titleBtn addTarget:navigationController action:@selector(titleBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        
        navigationController.visibleViewController.navigationItem.titleView = titleBtn;
        navigationController.title = titleBtn.titleLabel.text;
    }
}

@end
