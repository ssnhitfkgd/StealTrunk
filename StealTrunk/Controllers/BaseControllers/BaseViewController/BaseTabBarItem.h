//
//  BaseTabBarItem.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import <Foundation/Foundation.h>

@interface BaseTabBarItem : NSObject

@property (nonatomic, strong) UIViewController *tabController;
@property (nonatomic, copy) NSString *tabTitle;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *unselectedImage;

+ (BaseTabBarItem *)creatWithTabController:(UIViewController *)tabController SelectedImage:(UIImage *)selectedImage UnselectedImage:(UIImage *)unselectedImage;

@end
