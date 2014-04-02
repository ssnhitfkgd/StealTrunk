//
//  MessageListCell.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-14.
//
//

#import <UIKit/UIKit.h>
#import "TableCellDelegate.h"

@class MessageListView;
@interface MessageListCell : UITableViewCell<TableCellDelegate>

@property (nonatomic, strong) MessageListView *cellView;

@end
