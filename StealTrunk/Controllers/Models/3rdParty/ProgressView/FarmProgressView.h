//
//  FarmProgressView.h
//  StealTrunk
//
//  Created by wangyong on 13-8-28.
//
//

#import <UIKit/UIKit.h>
#import "DDProgressView.h"


@interface FarmProgressView : UIView
{
    DDProgressView *experienceProgressView;
    DDProgressView *powerProgressView;
    DDProgressView *coinProgressView;
    DDProgressView *diamondProgressView;
}

+ (FarmProgressView*)shareInstance;
- (void)setExperienceProgress:(CGFloat)progress;

- (void)setPowerProgress:(CGFloat)progress;

- (void)setCoinProgress:(CGFloat)progress;

- (void)setDiamondProgressView:(CGFloat)progress;
@end
