//
//  StampDTO.h
//  StealTrunk
//
//  Created by 点兄 on 13-8-8.
//
//

#import "DataModelBase.h"

@interface StampDTO : DataModelBase

@property (nonatomic, strong) Monstea_user_info *userInfo;
@property (nonatomic, copy) NSString *comment_to_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *like_type;
@property (nonatomic, copy) NSString *stampID;

@end
