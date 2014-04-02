//
//  TribeCell.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-20.
//
//

#import <UIKit/UIKit.h>
#import "TribeView.h"
#import "TableCellDelegate.h"


@interface TribeCell : UITableViewCell<TableCellDelegate>

@property (nonatomic, strong) TribeView *cellView;

@end
