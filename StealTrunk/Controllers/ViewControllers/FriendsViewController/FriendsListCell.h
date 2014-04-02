//
//  FriendsListCell.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import <UIKit/UIKit.h>
#import "FriendsListView.h"
#import "TableCellDelegate.h"

@interface FriendsListCell : UITableViewCell<TableCellDelegate>

@property(nonatomic, strong) FriendsListView *friendsListView;

@end
