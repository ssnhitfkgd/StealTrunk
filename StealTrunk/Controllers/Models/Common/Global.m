//
//  Global.m
//  StealTrunk
//
//  Created by wangyong on 13-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Global.h"
#import "Reachability.h"
//#import "ColorUtil.h"

@implementation Global

UINavigationController *selected_navigation_controller()
{
    if((UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController.presentedViewController)
        return (UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController.presentedViewController;
    else
        return  (UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController;
        
}
+ (NSString *)getServerBaseUrl {
    return @"http://42.96.186.99:8899/";
}

+ (NSString *)getAppVersion
{
    return @"1";
}



@end

@implementation UIColor (RGB)
+ (UIColor *)colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b {
    return [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1.];
}
@end
