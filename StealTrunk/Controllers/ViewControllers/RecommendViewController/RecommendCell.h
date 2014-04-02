//
//  RecommendCell.h
//  StealTrunk
//
//  Created by yong wang on 13-4-24.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableCellDelegate.h"
@class RecommendView;

@interface RecommendCell : UITableViewCell<TableCellDelegate>


@property (nonatomic, strong) RecommendView *recomendView;
@end
