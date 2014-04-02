//
//  GetNearbyPlacesView.h
//  StealTrunk
//
//  Created by wangyong on 13-7-4.
//
//

#import "BaseView.h"
#import "TableCellDelegate.h"
#import "GetLocationDto.h"

@interface GetNearbyPlacesView : BaseView<TableCellDelegate>

@property(nonatomic, strong) UIImageView *placeTipImageView;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) GetLocationDto *locationDto;

- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

@end
