//
//  UserStatusCell.h
//  StealTrunk
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import "UserStatusView.h"
#import "TableCellDelegate.h"

@interface UserStatusCell : UITableViewCell<TableCellDelegate>


@property (nonatomic, strong) UserStatusListView *clipView;
@end
