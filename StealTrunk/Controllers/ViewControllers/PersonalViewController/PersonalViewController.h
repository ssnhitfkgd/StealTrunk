//
//  PersonalViewController.h
//  StealTrunk
//
//  Created by wangyong on 13-7-17.
//
//

#import <UIKit/UIKit.h>
#import "TableApiViewController.h"
#import "UserStatusViewController.h"

typedef enum
{
    USER_STATUS = 0,//个人动态
    USER_DESIRE,
}PERSONAL_TYPE;


@interface PersonalViewController : TableApiViewController<UserStatusDelegate>

- (id)initWithUserInfo:(Monstea_user_info *)userInfo;

@end
