//
//  LBLoginViewController.h
//  StealTrunk
//
//  Created by yong wang on 13-3-26.
//  Copyright (c) 2013年StealTrunk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UIScrollViewDelegate>
{
    UIPageControl           *pageControl;
    UIScrollView            *beginScroll;
}

- (void)sinaDidLogin:(id)accountEnitity;

@end
