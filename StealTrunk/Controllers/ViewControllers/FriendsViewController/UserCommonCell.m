//
//  FriendsAddCell.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "UserCommonCell.h"


@implementation UserCommonCell
@synthesize cellView = _cellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellView = [[UserCommonCellView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        
        [self.contentView addSubview:_cellView];
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
    return [UserCommonCellView rowHeightForObject:item];
}

@end
