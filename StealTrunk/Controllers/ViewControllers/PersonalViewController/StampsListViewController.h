//
//  StampsListViewController.h
//  StealTrunk
//
//  Created by 点兄 on 13-8-9.
//
//

#import "TableApiViewController.h"

@class UserStatusInfoDto;

@interface StampsListViewController : TableApiViewController

@property (nonatomic, strong) UserStatusInfoDto *DTO;

@end
