//
//  TaskCell.m
//  StealTrunk
//
//  Created by wangyong on 13-8-20.
//
//

#import "TaskCell.h"

@implementation TaskCell

@synthesize cellView = _cellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellView = [[TaskView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        [self.contentView addSubview:self.cellView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

- (void)setObject:(id)item
{
    if(_cellView)
    {
        [_cellView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [TaskView rowHeightForObject:item];
}

@end
