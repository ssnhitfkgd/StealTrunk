//
//  ScoreView.h
//  StealTrunk
//
//  Created by wangyong on 13-8-20.
//
//

#import "BaseView.h"
#import "ScoreDto.h"

@interface ScoreView : BaseView

@property (nonatomic, strong) UIImageView *scorePhotoImageView;
@property (nonatomic, strong) UILabel *scoreNameLabel;
@property (nonatomic, strong) UILabel *scoreDescriptionLabel;
@property (nonatomic, strong) UIView *scoreState;

@property (nonatomic, strong) ScoreDto *scoreDto;

- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

@end
