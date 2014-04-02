//
//  FriendsAddCell.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import <UIKit/UIKit.h>
#import "UserCommonCellView.h"
#import "TableCellDelegate.h"

@interface UserCommonCell : UITableViewCell<TableCellDelegate>

@property (nonatomic, strong) UserCommonCellView *cellView;

@end
