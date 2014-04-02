//
//  StampCellView.h
//  StealTrunk
//
//  Created by 点兄 on 13-8-9.
//
//

#import "BaseView.h"

@class StampDTO;

@interface StampCellView : BaseView

@property (nonatomic, strong) StampDTO *DTO;

- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

@end
