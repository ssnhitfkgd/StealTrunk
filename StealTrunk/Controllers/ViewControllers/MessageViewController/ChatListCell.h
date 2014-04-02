//
//  ChatListCell.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-14.
//
//

#import <UIKit/UIKit.h>
#import "ChatListView.h"
#import "TableCellDelegate.h"

@interface ChatListCell : UITableViewCell<TableCellDelegate>
@property (nonatomic, strong) ChatListView *cellView;

- (NSString*)getChatToUserID;
- (NSString*)getChatToUserName;
@end
