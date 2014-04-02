//
//  UserStatusCell.m
//  StealTrunk
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import "UserStatusCell.h"

@implementation UserStatusCell
@synthesize clipView = _clipView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipView = [[UserStatusListView alloc] init];
        [self.contentView addSubview:_clipView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setObject:(id)item
{
    if(_clipView)
    {
        [_clipView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [UserStatusListView rowHeightForObject:item];
}


@end
