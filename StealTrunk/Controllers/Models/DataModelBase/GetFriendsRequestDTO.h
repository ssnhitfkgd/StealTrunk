//
//  GetFriendsAddDTO.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "DataModelBase.h"

@interface GetFriendsRequestDTO : DataModelBase

@property (nonatomic, strong) Monstea_user_info *userInfo;

@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *msg_id;
@property (nonatomic, assign) BOOL is_readed;

@end
