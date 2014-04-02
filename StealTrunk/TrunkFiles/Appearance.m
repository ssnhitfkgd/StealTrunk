//
//  Appearance.h
//  StealTrunk
//
//  Created by wangyong on 13-7-11.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import "Appearance.h"

@implementation Appearance

+ (void)setAppearance
{
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"emptyIMG"]];
    [[UITabBar appearance] setBackgroundImage: [UIImage imageNamed:@"tabbar"]];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"emptyIMG"]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : RGB140 } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : BenBlue } forState:UIControlStateHighlighted];

    [[UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil] setBackgroundImage:[[UIImage imageNamed:@"navigationbar"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forBarMetrics:UIBarMetricsDefault];
    
}

@end
