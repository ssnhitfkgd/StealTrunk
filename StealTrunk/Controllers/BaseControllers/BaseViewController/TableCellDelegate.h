//
//  TableCellDelegate.h
//  StealTrunk
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年StealTrunk. All rights reserved.
//

@protocol TableCellDelegate <NSObject>

+ (CGFloat)rowHeightForObject:(id)item;
@optional
- (void)setObject:(id)item;
- (void)loadCacheInfo:(id)info;
- (void)clearCacheInfo:(id)info;
@end
