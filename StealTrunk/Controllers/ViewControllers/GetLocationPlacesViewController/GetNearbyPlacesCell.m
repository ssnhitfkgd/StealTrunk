//
//  GetNearbyPlacesCell.m
//  StealTrunk
//
//  Created by wangyong on 13-7-4.
//
//

#import "GetNearbyPlacesCell.h"

@implementation GetNearbyPlacesCell
@synthesize nearbyPlacesView = _nearbyPlacesView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nearbyPlacesView = [[GetNearbyPlacesView alloc] initWithFrame:CGRectMake(0, 12, 320, 0)];
        [self.contentView addSubview:_nearbyPlacesView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setObject:(id)item
{
    if(_nearbyPlacesView)
    {
        [_nearbyPlacesView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [GetNearbyPlacesView rowHeightForObject:item];
}

@end
