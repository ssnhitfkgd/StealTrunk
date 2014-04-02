//
//  DesireView.h
//  StealTrunk
//
//  Created by wangyong on 13-7-17.
//
//


#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface DesireView : BaseView


@property (nonatomic, retain) UIImageView *desireImageView;
@property (nonatomic, retain) UILabel *desireNameLabel;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIImageView *delImageView;
- (void)createSubview;
- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject;
@end
