//
//  BlockListCell.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-22.
//
//

#import <UIKit/UIKit.h>
#import "BlockListView.h"
#import "TableCellDelegate.h"

@interface BlockListCell : UITableViewCell<TableCellDelegate>

@property (nonatomic, strong) BlockListView *cellView;

@end
