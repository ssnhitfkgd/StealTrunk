//
//  BaseNavigationViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import <UIKit/UIKit.h>

@interface BaseNavigationViewController : UINavigationController<UINavigationControllerDelegate>

/*
 默认设置了导航title字体样式，并且title取自rootViewController的title，不用二次设置
 barImage：默认设置了导航背景，在需要自定义导航背景的页面填入barImage，没有的就填nil
 needDismiss：在root页面默认设置关闭按钮，不需要就设置为false
 */
+ (BaseNavigationViewController *)creataWithRootViewController:(UIViewController *)rootViewController CustomBarImage:(UIImage *)barImage NeedDismiss:(BOOL)needDismiss;

@end
