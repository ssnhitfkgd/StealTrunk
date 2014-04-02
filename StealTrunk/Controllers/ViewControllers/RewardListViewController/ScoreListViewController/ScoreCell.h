//
//  ScoreCell.h
//  StealTrunk
//
//  Created by wangyong on 13-8-20.
//
//

#import <UIKit/UIKit.h>
#import "ScoreView.h"
#import "TableCellDelegate.h"


@interface ScoreCell : UITableViewCell<TableCellDelegate>

@property (nonatomic, strong) ScoreView *cellView;

@end
