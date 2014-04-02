//
//  BlockListView.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-22.
//
//

#import "BaseView.h"

@interface BlockListView : BaseView



@property (nonatomic, strong) Monstea_user_info *userInfo;

- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

@end
