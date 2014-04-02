//
//  FriendInfoDto.h
//  StealTrunk
//
//  Created by wangyong on 13-7-3.
//
//

#import "DataModelBase.h"

@interface UserStatusInfoDto : DataModelBase
{
    Monstea_user_info *userInfo;
    
    NSString *status_audio;
    NSDate *__weak status_create_time;
    NSInteger status_like_count;
    NSInteger status_comment_count;
    NSString *status_content;
    
}

@property (nonatomic, readonly) NSString *status_audio;
@property (weak, nonatomic, readonly) NSDate *status_create_time;
@property (nonatomic, assign) NSInteger status_like_count;
@property (nonatomic, assign) NSInteger status_comment_count;
@property (nonatomic, readonly) NSString *status_content;
@property (nonatomic, readonly) NSString *status_id;

@property (nonatomic, strong) Monstea_user_info *userInfo;

- (BOOL)parse2:(NSDictionary *)result;
- (BOOL)parse:(NSDictionary *)dict;
@end
