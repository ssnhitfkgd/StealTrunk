//
//  LBLoginViewController.m
//  StealTrunk
//
//  Created by yong wang on 13-3-26.
//  Copyright (c) 2013年StealTrunk. All rights reserved.
//

#import "LoginViewController.h"
#import "FileClient.h"
#import "GuideUserInfoViewController.h"
#import "UMSocialAFHTTPClient.h"
#import "UMUtils.h"
#import "GameSoundsManager.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    //if()
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 这里判断是否第一次
        beginScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        beginScroll.backgroundColor = [UIColor blackColor];
        beginScroll.pagingEnabled = YES;
        beginScroll.delegate = self;
        beginScroll.showsHorizontalScrollIndicator = NO;
        beginScroll.contentSize = CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height);
        [self.view addSubview:beginScroll];
        
        NSArray *images = [[NSArray alloc] initWithObjects:@"begin_one.png", @"begin_two.png", @"begin_three.png", @"begin_four.png", nil];
        for (int i = 0; i<4; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, self.view.frame.size.width, self.view.frame.size.height)];
            imageView.image = [UIImage imageNamed:[images objectAtIndex:i]];
            imageView.tag = 996 + i;
            [beginScroll addSubview:imageView];
        }
        
        UIImageView *lastView = (UIImageView *)[self.view viewWithTag:999];
        lastView.userInteractionEnabled = YES;
        UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        lastButton.frame = CGRectMake(12.5, self.view.frame.size.height - 130, 295, 92);
        [lastButton setImage:[UIImage imageNamed:@"begin_button.png"] forState:UIControlStateNormal];
        [lastButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        [lastView addSubview:lastButton];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 55, 320, 20)];
        pageControl.numberOfPages = 4;
        [self.view addSubview:pageControl];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }

    [self createUI];
	// Do any additional setup after loading the view.
}

- (void)createUI
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bottom_background"]];
    [imageView setFrame:CGRectMake(0, screenSize().height - 188, screenSize().width, 144)];
    [imageView setUserInteractionEnabled:YES];
    
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaButton setTag:1];
    [sinaButton setBackgroundImage: [ImageCenter getBundleImage:@"btn_sina_background.png"] forState:UIControlStateNormal];
    [sinaButton setBackgroundImage:[ImageCenter getBundleImage:@"btn_sina_background_tape"] forState:UIControlStateHighlighted];
    sinaButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sinaButton setTitle:NSLocalizedString(@"新浪微博登录", nil) forState:UIControlStateNormal];
    sinaButton.titleLabel.shadowColor = [UIColor blackColor];
    sinaButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    sinaButton.titleEdgeInsets = UIEdgeInsetsMake(0, 32, 0, 0);
    [sinaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sinaButton setFrame: CGRectMake(6, 4, 308, 38)];
    [sinaButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:sinaButton];
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqButton setTag:2];
    [qqButton setBackgroundImage: [ImageCenter getBundleImage:@"btn_sina_background.png"] forState:UIControlStateNormal];
    [qqButton setBackgroundImage:[ImageCenter getBundleImage:@"btn_sina_background_tape"] forState:UIControlStateHighlighted];
    qqButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [qqButton setTitle:NSLocalizedString(@"QQ登录", nil) forState:UIControlStateNormal];
    qqButton.titleLabel.shadowColor = [UIColor blackColor];
    qqButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    qqButton.titleEdgeInsets = UIEdgeInsetsMake(0, 32, 0, 0);
    [qqButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qqButton setFrame: CGRectMake(6, sinaButton.bottom + 10, 308, 38)];
    [qqButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:qqButton];
    [qqButton setBackgroundColor:[UIColor redColor]];
    [imageView setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:imageView];
 
}

//登陆
- (void)loginBtnClick:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
    
    //用新浪登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:(sender.tag == 1)?UMShareToSina:UMShareToQzone];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //获取accesstoken
        [[UMSocialDataService defaultDataService] requestSnsInformation:(sender.tag == 1)?UMShareToSina:UMShareToQzone  completion:^(UMSocialResponseEntity *response){
            
            //判断平台
            [AccountDTO saveSina:response.data];
            [self sinaDidLogin:[[AccountDTO sharedInstance] sina_user_info]];
            
        }];
    });
    
}

#pragma mark - Delegate for SinaHelper
- (void)sinaDidLogin:(id)accountEnitity
{
    Sina_user_info *sina = (Sina_user_info *)accountEnitity;
    
    NSString *token = sina.access_token;
    if(!token || [token isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"未取到sina token"];
    }
    
    FileClient *client = [FileClient sharedInstance];
    [client loginBySinaToken:@"weibo" token:token cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"骚等...", nil) maskType:SVProgressHUDMaskTypeBlack];
}

- (void)requestDidFinishLoad:(NSData*)data
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
                [AccountDTO saveUserInfo:dict];
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"登录成功", nil)];
                [[GameSoundsManager sharedGameSoundsManager] playBackgroundMusic];
                
                //新用户进入Giude,老用户进入游戏
                Monstea_user_info *monstea = [[AccountDTO sharedInstance] monstea_user_info];
                if (monstea.show == 0) {
                    [self pushController:0];
                }else{
                    [[AppController shareInstance] setMainViewController];
                }
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

- (void)requestError:(NSError *)data {
    NSLog(@"%@", data);
    
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登陆失败，请重新登录", nil)];
    
#warning 登出～
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - guideController
- (void)pushController:(int)pageIndex
{
    GuideUserInfoViewController *userInfoGuide = [[GuideUserInfoViewController alloc] init];
    
    UINavigationController *guideNavi = [[UINavigationController alloc] initWithRootViewController:userInfoGuide];
    guideNavi.navigationBarHidden = YES;
    [[UIApplication sharedApplication].keyWindow setRootViewController:guideNavi];
}

- (void)loadNextPageViewController
{
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    pageControl.currentPage = beginScroll.contentOffset.x / 320;
}

@end
