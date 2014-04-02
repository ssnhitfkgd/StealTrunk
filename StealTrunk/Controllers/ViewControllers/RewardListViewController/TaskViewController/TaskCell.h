//
//  TaskCell.h
//  StealTrunk
//
//  Created by wangyong on 13-8-20.
//
//

#import <UIKit/UIKit.h>
#import "TaskView.h"
#import "TableCellDelegate.h"

@interface TaskCell : UITableViewCell<TableCellDelegate>

@property (nonatomic, strong) TaskView *cellView;
@end
