//
//  UserStatusViewController.h
//  StealTrunk
//
//  Created by wangyong on 13-7-28.
//
//

#import "TableApiViewController.h"
#import "UserStatusInfoDto.h"

@protocol UserStatusDelegate <NSObject>

- (void)deleteStatus:(UserStatusInfoDto *)statusDTO;

@end

@interface UserStatusViewController : TableApiViewController<UIActionSheetDelegate>

@property (nonatomic, assign) id<UserStatusDelegate>delegate;
@property (nonatomic, strong) UserStatusInfoDto *statusDto;

- (id)initWithUserStatusDto:(UserStatusInfoDto*)userStatusDto;
@end
