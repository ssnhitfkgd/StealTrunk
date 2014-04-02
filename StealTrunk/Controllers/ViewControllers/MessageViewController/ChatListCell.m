//
//  ChatListCell.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-14.
//
//

#import "ChatListCell.h"
@implementation ChatListCell
@synthesize cellView = _cellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellView = [[ChatListView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        [self.contentView addSubview:_cellView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

- (NSString*)getChatToUserID
{
    return [_cellView getChatToUserID];
}

- (NSString*)getChatToUserName
{
    return [_cellView getChatToUserName];
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
    return [ChatListView rowHeightForObject:item];
}

@end
