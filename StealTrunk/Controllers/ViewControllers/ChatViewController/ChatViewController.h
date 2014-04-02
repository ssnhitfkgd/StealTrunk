//
//  ChatViewController.h
//  StealTrunk
//
//  Created by wangyong on 13-7-19.
//
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "ModelApiViewController.h"
#import "SocketDataCommon.h"
#import "RichInputView.h"

@class UIBubbleTableView;

@interface ChatViewController : ModelApiViewController <UIBubbleTableViewDataSource,UITableViewDataSource,UITableViewDelegate,SocketDataCommonDelegate,RichInputViewDelegate>
{
    UIBubbleTableView *bubbleTable;
    NSString *chatToUserID;
}

@property (nonatomic, strong) NSMutableArray *bubbleData;
@property (nonatomic, strong) RichInputView *inputView;
@property (nonatomic, strong) UIView *contentView;

- (id)initWithChatToUserID:(NSString*)toUserID;
- (NSString*)getChatToUserID;

@end
