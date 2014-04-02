//
//  FriendsNewsViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "TableApiViewController.h"
#import "UserStatusViewController.h"

@interface FriendsNewsViewController : TableApiViewController<UserStatusDelegate>

- (void)postBtnPress:(id)sender;

@end
