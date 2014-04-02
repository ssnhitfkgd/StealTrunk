//
//  GuideShowViewController.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-21.
//
//

#import "GuideShowViewController.h"
#import "FileClient.h"
#import "AppDelegate.h"

@interface GuideShowViewController ()

@end

@implementation GuideShowViewController
@synthesize userInfo = _userInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame = CGRectMake(0, 0, 320, 44);
        nextBtn.backgroundColor = [UIColor purpleColor];
        [nextBtn setTitle:NSLocalizedString(@"进入游戏", nil) forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        
        nextBtn.bottom = [[UIScreen mainScreen] bounds].size.height-20;
        
        [self.view addSubview:nextBtn];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (GuideShowViewController *)creatWithUserInfo:(Monstea_user_info *)userInfo
{
    GuideShowViewController *control = [[GuideShowViewController alloc] init];
    control.userInfo = userInfo;
    
    //for test
    control.userInfo.show = @"show time !";
    
    return control;
}

#pragma mark - Actions
- (void)nextBtnPress:(id)sender
{
    [[FileClient sharedInstance] updateMyProfile:self.userInfo avatar:nil delegate:self selector:@selector(requestFinsh:) selectorError:@selector(requestError:) progressSelector:nil];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在保存...", nil) maskType:SVProgressHUDMaskTypeGradient];
    //push
//    GuideTribeViewController *tribeControl = [[GuideTribeViewController alloc] init];
//    [self.navigationController pushViewController:tribeControl animated:YES];
}

#pragma mark -
- (void)requestFinsh:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"code"];
        if(responseObject && 0 == [responseObject integerValue])
        {
            NSDictionary *dict = [[json_string JSONValue]  objectForKey:@"data"];
            if(dict)
            {
                Monstea_user_info *userInfo = [[Monstea_user_info alloc] init];
                [userInfo parseWithDic:dict];
                [AccountDTO saveMonstea:userInfo];
                
                [[AppController shareInstance] setMainViewController];
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"成功", nil)];
            }
            else
            {
                [self requestError:nil];
            }
        }
        else
        {
            [self requestError:nil];
        }
    }
    
    else {
        [self requestError:nil];
    }
}

- (void)requestError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"失败", nil)];
}

@end
