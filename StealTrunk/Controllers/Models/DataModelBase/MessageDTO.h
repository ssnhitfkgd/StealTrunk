//
//  MessageDTO.h
//  StealTrunk
//
//  Created by 点兄 on 13-7-14.
//
//

#import "DataModelBase.h"

@interface MessageDTO : DataModelBase

@property (nonatomic, copy) NSString *message_id;
@property (nonatomic, copy) NSString *message_type;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) BOOL is_readed;

@property (nonatomic, strong) Monstea_user_info *userInfo;

- (BOOL)parse2:(NSDictionary *)result;
- (BOOL)parse:(NSDictionary *)dict;


@end
