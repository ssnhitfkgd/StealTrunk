//
//  AppDelegate.mm
//  StealTrunk
//
//  Created by wangyong on 13-6-21.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import "cocos2d.h"
#import "AppDelegate.h"
#import "IntroLayer.h"
#import "UMSocial.h"
#import "LoginViewController.h"
#import "Appearance.h"
//add by kevin
#import "GuideUserInfoViewController.h"
#import "TempLauchView.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

+ (id)shareInstance{
    
    return (id)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString *access_token = [self getParamValueFromUrl:[url absoluteString] paramName:@"access_token"];
    NSString *expires_in = [self getParamValueFromUrl:[url absoluteString] paramName:@"expires_in"];
    NSString *remind_in = [self getParamValueFromUrl:[url absoluteString] paramName:@"remind_in"];
    NSString *uid = [self getParamValueFromUrl:[url absoluteString] paramName:@"uid"];
    NSString *refresh_token = [self getParamValueFromUrl:[url absoluteString] paramName:@"refresh_token"];
    
    NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
    if (access_token) [authInfo setObject:access_token forKey:@"access_token"];
    if (expires_in) [authInfo setObject:expires_in forKey:@"expires_in"];
    if (remind_in) [authInfo setObject:remind_in forKey:@"remind_in"];
    if (refresh_token) [authInfo setObject:refresh_token forKey:@"refresh_token"];
    if (uid) [authInfo setObject:uid forKey:@"uid"];
    
    [[NSUserDefaults standardUserDefaults] setObject:authInfo forKey:@"sianUserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //本地通知 add by kevin
    [self startPushLocalNotification];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone]; //隐藏状态栏 //add by kevin
    
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	
	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	// Enable multiple touches
	[glView setMultipleTouchEnabled:YES];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF
	[director_ setDisplayStats:YES];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// for rotation and other messages
	[director_ setDelegate:self];
	[director_ setDisplayStats:NO];
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
	
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	[director_ pushScene: [IntroLayer scene]]; 
	
    //向微信注册
    //wx502b9382d471de2e
    [WXApi registerApp:@"wx502b9382d471de2e"];

    [MobClick startWithAppkey:@"51ae9bda56240bf5aa01bc9b" reportPolicy:REALTIME channelId:nil];  
    [UMSocialData openLog:YES]; 
    [UMSocialData setAppKey:@"51ae9bda56240bf5aa01bc9b"];
    
    [self setMainViewController];
	
	// set the Navigation Controller as the root view controller
//	[window_ addSubview:navController_.view];	// Generates flicker.
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
    
    
    [Appearance setAppearance];
   	
	return YES;
}

- (void)againLogin
{
    navController_ = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc ] init]];
    navController_.navigationBarHidden = YES;
    [window_ setRootViewController:navController_];
}

- (void)logout
{
    //清除本地数据
    [AccountDTO cleanAccountDTO];
    
    //跳转到登录页
    [self againLogin];
}

- (void)setMainViewController
{
    // Create a Navigation Controller with the Director
    
//    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:snsPlatform.platformName];
 
    Session *session = [[AccountDTO sharedInstance] session_info];
    if (session.token && ![session.token isEqualToString:@""]) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
        
        navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
        TempLauchView *lauchView = [[[NSBundle mainBundle] loadNibNamed:@"TempLauchView" owner:self options:nil] lastObject];
        lauchView.top = 0;
        //[lauchView setUserInteractionEnabled:NO];
        [navController_.view addSubview:lauchView];

    }else{
        GuideUserInfoViewController *userInfoGuide = [[GuideUserInfoViewController alloc] init];
        
        UINavigationController *guideNavi = [[UINavigationController alloc] initWithRootViewController:userInfoGuide];
        guideNavi.navigationBarHidden = YES;
        [[UIApplication sharedApplication].keyWindow setRootViewController:guideNavi];
        navController_ = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc ] init]];
    }

    navController_.navigationBarHidden = YES;
    [window_ setRootViewController:navController_];

}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;

	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
    
    [UMSocialSnsService  applicationDidBecomeActive];
}


-(void) applicationDidEnterBackground:(UIApplication*)application
{
    application.applicationIconBadgeNumber = 0;//外部提示清0

	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
    application.applicationIconBadgeNumber = 0;//外部提示清0

	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken %@", deviceToken);
    //
    NSString *tokenStr = [deviceToken description];
    NSString *pushToken = [[[tokenStr
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *localToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if ([pushToken isEqualToString:localToken] == NO) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"bindDevice"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification %@", userInfo);
}

//本地通知，提高留存率
- (void)startPushLocalNotification
{
    for (UILocalNotification *subNotify in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([subNotify.alertAction isEqualToString:NSLocalizedString(@"游戏!", nil)]) {
            [[UIApplication sharedApplication] cancelLocalNotification:subNotify];
        }
    }
    
    NSArray *alertBodies = [NSArray arrayWithObjects:
                            NSLocalizedString(@"今天的作物长的很好噢!╭(╯3╰)╮", nil)
                            ,NSLocalizedString(@"搬来了好多邻居，快来认识下吧！O(∩_∩)O", nil)
                            ,NSLocalizedString(@"主人，你去哪里了？农场都要荒废了...", nil)
                            ,NSLocalizedString(@"爱过...", nil)
                            ,nil];
    
    NSDate* now = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	comps = [calendar components:unitFlags fromDate:now];
	int hour = [comps hour];
	int min = [comps minute];
	int sec = [comps second];
	
	int clockHour = 20;
	int clockMinute = 00;
    
	int hourDiff = clockHour-hour;
	int minDiff = clockMinute-min;
    
    NSTimeInterval diff = (hourDiff*3600)+(minDiff*60)-sec;
    
    for (int i=0; i<alertBodies.count; i++) {
        UILocalNotification *notify = [[UILocalNotification alloc] init];
        notify.timeZone = [NSTimeZone defaultTimeZone];
        
        NSDate *clockDate;
        
        if (i == 0) {
            clockDate = [NSDate dateWithTimeIntervalSinceNow:(diff + 24*60*60)];
#ifdef USER_kevinluo
            NSLog(@"clock %@",[clockDate description]);
#endif
        }else if (i == 1){
            clockDate = [NSDate dateWithTimeIntervalSinceNow:(diff + 3*24*60*60)];
        }else if (i == 2){
            clockDate = [NSDate dateWithTimeIntervalSinceNow:(diff + 7*24*60*60)];
        }else if (i == 3){
            clockDate = [NSDate dateWithTimeIntervalSinceNow:(diff + 30*24*60*60)];
        }
        
        notify.fireDate = clockDate;
        notify.timeZone = [NSTimeZone defaultTimeZone];
        notify.alertBody = [alertBodies objectAtIndex:i];
        notify.alertAction = NSLocalizedString(@"游戏!", nil);
        notify.soundName = @"localNotify.mp3";
        [[UIApplication sharedApplication]   scheduleLocalNotification:notify];
    }
}

@end

