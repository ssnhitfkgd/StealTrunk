//
//  BlockListCell.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-22.
//
//

#import "BlockListCell.h"

@implementation BlockListCell
@synthesize cellView = _cellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellView = [[BlockListView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
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
    return [BlockListView rowHeightForObject:item];
}

@end
