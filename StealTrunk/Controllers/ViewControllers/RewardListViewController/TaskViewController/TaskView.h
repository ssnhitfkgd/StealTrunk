//
//  TaskView.h
//  StealTrunk
//
//  Created by wangyong on 13-8-20.
//
//

#import "BaseView.h"
#import "TaskDto.h"

@interface TaskView : BaseView

@property (nonatomic, strong) UIImageView *taskPhotoImageView;
@property (nonatomic, strong) UILabel *taskNameLabel;
@property (nonatomic, strong) UILabel *taskDescriptionLabel;
@property (nonatomic, strong) UIView *taskState;

@property (nonatomic, strong) TaskDto *taskDto;

- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

@end
