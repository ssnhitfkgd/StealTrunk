//
//  LBLoginViewController.m
//  StealTrunk
//
//  Created by yong wang on 13-3-26.
//  Copyright (c) 2013年StealTrunk. All rights reserved.
//

#import "LoginViewController.h"
#import "FileClient.h"
#import "GuideViewController.h"


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
        beginScroll = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)] autorelease];
        beginScroll.backgroundColor = [UIColor blackColor];
        beginScroll.pagingEnabled = YES;
        beginScroll.delegate = self;
        beginScroll.showsHorizontalScrollIndicator = NO;
        beginScroll.contentSize = CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height);
        [self.view addSubview:beginScroll];
        
        NSArray *images = [[[NSArray alloc] initWithObjects:@"begin_one.png", @"begin_two.png", @"begin_three.png", @"begin_four.png", nil] autorelease];
        for (int i = 0; i<4; i++) {
            UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
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
        
        pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 55, 320, 20)] autorelease];
        pageControl.numberOfPages = 4;
        [self.view addSubview:pageControl];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }

    [self createUI];
	// Do any additional setup after loading the view.
}

- (void)sinaGetUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"user info: %@", userInfo);
    
    //if (userInfo != nil) {
    //微博
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"screen_name"] forKey:@"screen_name"];
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"gender"] forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"avatar_large"] forKey:@"avatar_large"];
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"description"] forKey:@"description"];
    
    //}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    pageControl.currentPage = beginScroll.contentOffset.x / 320;
}

- (void)createUI
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bottom_background"]] autorelease];
    [imageView setFrame:CGRectMake(0, screenSize().height - 188, screenSize().width, 144)];
    [imageView setUserInteractionEnabled:YES];
    
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaButton setTag:1];
    [sinaButton setBackgroundImage: [ImageCenter getBundleImage:@"btn_sina_background.png"] forState:UIControlStateNormal];
    [sinaButton setBackgroundImage:[ImageCenter getBundleImage:@"btn_sina_background_tape"] forState:UIControlStateHighlighted];
    sinaButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sinaButton setTitle:@"使用新浪微博账号，一键登录" forState:UIControlStateNormal];
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
    [qqButton setTitle:@"QQ登录" forState:UIControlStateNormal];
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
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:(sender.tag == 1)?UMShareToSina:UMShareToQzone];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [[NSUserDefaults standardUserDefaults] setObject:response.data forKey:@"user_sina"];
        NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
        NSDictionary *dict = nil;
        id obj = [response.data objectForKey:@"accounts"];
        if(obj)
        {
            dict = [obj objectForKey:@"sina"];
        }
        else
        {
            dict = [response.data objectForKey:@"sina"];
        }
        [[AccountDTO sharedInstance] pause_sina_user_info:dict];
     
        UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:snsPlatform.platformName];
        [self sinaDidLogin:accountEnitity];

    });
}

#pragma mark - Delegate for SinaHelper

- (void)sinaDidLogin:(id)accountEnitity
{
    UMSocialAccountEntity *obj = (UMSocialAccountEntity *)accountEnitity;
    
    FileClient *client = [FileClient sharedInstance];
    [client loginBySinaToken:@"weibo" token:/*obj.accessToken*/@"2.006bCWrDcBQk4C7e7e29bdd7djxKUC" cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
    
    //[self loginBySinaToken];
    progressHUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    [self.navigationController.view addSubview:progressHUD];
    progressHUD.delegate = self;
    progressHUD.labelText = @"正在加载...";
//    [progressHUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [progressHUD show:YES];
}

- (void)requestDidFinishLoad:(NSData*)data
{
    
    NSString *json_string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"code"];
        if(responseObject && 0 == [responseObject integerValue])
        {
            NSDictionary *dict = [[json_string JSONValue]  objectForKey:@"data"];
            if(dict)
            {
                [[AccountDTO sharedInstance] pause_user_section:dict];
                
                [self pushController:0];
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
    [progressHUD setHidden:YES];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"登陆失败，请重新登录"];
    NSLog(@"ERROR");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - guideController
- (void)pushController:(int)pageIndex
{
    GuideViewController *controller = [[[GuideViewController alloc]  initPageIndex:0] autorelease];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
    [[UIApplication sharedApplication].keyWindow setRootViewController:navigationController];
}

- (void)loadNextPageViewController
{
}

@end
