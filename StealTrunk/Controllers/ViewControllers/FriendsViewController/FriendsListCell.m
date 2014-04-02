//
//  FriendsListCell.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "FriendsListCell.h"

@implementation FriendsListCell

@synthesize friendsListView = _friendsListView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.friendsListView = [[FriendsListView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        [self.contentView addSubview:_friendsListView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

- (void)setObject:(id)item
{
    if(_friendsListView)
    {
        [_friendsListView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [FriendsListView rowHeightForObject:item];
}

@end
