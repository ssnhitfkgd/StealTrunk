//
//  CommentCell.m
//  StealTrunk
//
//  Created by 点兄 on 13-8-6.
//
//

#import "CommentCell.h"

@implementation CommentCell
@synthesize cellView = _cellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellView = [[CommentView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        [self.contentView addSubview:self.cellView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setObject:(id)item
{
    if(_cellView)
    {
        [self.cellView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [CommentView rowHeightForObject:item];
}

@end
