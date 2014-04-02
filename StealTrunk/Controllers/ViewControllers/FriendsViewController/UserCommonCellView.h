//
//  FriendsAddView.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "BaseView.h"
#import "TableCellDelegate.h"

typedef enum
{
    USER_COMMON_CELL_TYPE_REQUEST = 0,
    USER_COMMON_CELL_TYPE_RECOMMEND,
    USER_COMMON_CELL_TYPE_BLOCKED,
}USER_COMMON_CELL_TYPE;

@protocol FriendsAddViewDelegate

- (void)agreeSuccess;

@end

@interface UserCommonCellView : BaseView<TableCellDelegate>

@property (nonatomic, strong) KKAvatarView *user_avatar;
@property (nonatomic, strong) UILabel *user_name;
@property (nonatomic, strong) UILabel *detail_text;
@property (nonatomic, strong) UIButton *add_btn;
@property (nonatomic, strong) UILabel *grade;

@property (nonatomic, assign) USER_COMMON_CELL_TYPE viewType;

@property (nonatomic, strong) NSObject *DTO;

@property (nonatomic, assign) id <FriendsAddViewDelegate> delegate;

- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject:(id)item;

- (void) addBtnPress:(id)sender;

@end
