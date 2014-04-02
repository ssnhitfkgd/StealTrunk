//
//  TaskView.m
//  StealTrunk
//
//  Created by wangyong on 13-8-20.
//
//

#import "TaskView.h"

@implementation TaskView
@synthesize taskPhotoImageView = _taskPhotoImageView;
@synthesize taskNameLabel = _taskNameLabel;
@synthesize taskDescriptionLabel = _taskDescriptionLabel;
@synthesize taskState = _taskState;

@synthesize taskDto = _taskDto;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubview];
        
        self.clipsToBounds = YES;
        self.height = 70;
        self.backgroundColor = [UIColor brownColor];
    }
    return self;
}


+ (CGFloat)rowHeightForObject:(id)item
{
    return 70;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.taskDto = [[TaskDto alloc] init];
        if([_taskDto parse2:item])
        {
            [_taskPhotoImageView setImageWithURL:[NSURL URLWithString:_taskDto.task_photo_url]];
            [_taskNameLabel setText: _taskDto.task_name];
            [_taskDescriptionLabel setText:_taskDto.task_description];
        }
    }
    
    [self setNeedsLayout];
}

- (void)createSubview
{
    self.taskPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 34)];
    _taskPhotoImageView.backgroundColor = [UIColor redColor];
    
    self.taskNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_taskPhotoImageView.right + 10, 0, 200, 20)];
    [_taskNameLabel setFont:[UIFont systemFontOfSize:14]];
    _taskNameLabel.backgroundColor = [UIColor blueColor];
    
    self.taskDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_taskPhotoImageView.right + 10, 0, 0, 20)];
    [_taskNameLabel setFont:[UIFont systemFontOfSize:14]];
    _taskDescriptionLabel.bottom = _taskPhotoImageView.bottom;
    _taskDescriptionLabel.backgroundColor = [UIColor greenColor];
    
  
    [self addSubview:_taskPhotoImageView];
    [self addSubview:_taskNameLabel];
    [self addSubview:_taskDescriptionLabel];
}


@end
