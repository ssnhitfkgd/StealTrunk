//
//  StampCell.m
//  StealTrunk
//
//  Created by 点兄 on 13-8-9.
//
//

#import "StampCell.h"
#import "StampCellView.h"

@implementation StampCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.cellView = [[StampCellView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        [self.contentView addSubview:self.cellView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return [StampCellView rowHeightForObject:item];
}

@end
