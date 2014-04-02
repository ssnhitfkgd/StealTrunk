//
//  ChatDto.h
//  StealTrunk
//
//  Created by wangyong on 13-7-22.
//
//

#import "DataModelBase.h"

@interface Chat_message : DataModelBase

@property (nonatomic, copy) NSString *chat_id;
@property (nonatomic, assign) unsigned int chat_type;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *audio;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *from;

- (void)parseWithDic:(NSDictionary *)dic;

@end

@interface ChatDto : DataModelBase

@property (nonatomic, strong) Chat_message *chatMessage;
@property (nonatomic, strong) Monstea_user_info *userInfo;

- (BOOL)parse2:(NSDictionary *)result;
@end
