//
//  RecommendCell.m
//  StealTrunk
//
//  Created by yong wang on 13-4-24.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import "RecommendCell.h"
#import "RecommendView.h"

@implementation RecommendCell
@synthesize recomendView = _recomendView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.recomendView = [[RecommendView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        [self.contentView addSubview:_recomendView];
        // Initialization code
    }
    return self;
}

- (void)setObject:(id)item
{
    if(_recomendView)
    {
        [_recomendView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [RecommendView rowHeightForObject:item];
}

@end
