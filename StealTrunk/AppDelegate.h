//
//  AppDelegate.h
//  StealTrunk
//
//  Created by wangyong on 13-6-21.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
	
	CCDirectorIOS	*__weak director_;							// weak ref
}

@property (nonatomic, strong) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (weak, readonly) CCDirectorIOS *director;

+ (id)shareInstance;
- (void)setMainViewController;
- (void)againLogin;
- (void)logout;

@end
