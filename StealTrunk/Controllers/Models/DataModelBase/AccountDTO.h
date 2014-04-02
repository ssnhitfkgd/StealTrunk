//
//  AccountDTO.h
//
//  Created by wangyong on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModelBase.h"

#define SINA_USER_INFO @"sina_user_info"
#define MONSTEA_USER_INFO @"monstea_user_info"
#define SESSION_INFO @"session_info"

/////////////////////////////////////////Session/////////////////////////////////////////
@interface Session : DataModelBase

@property (nonatomic, copy) NSString *login_type;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *host;

- (void)parseWithDic:(NSDictionary *)dic;

@end


/////////////////////////////////////////Sina_user_info/////////////////////////////////////////
@interface Sina_user_info : DataModelBase

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *profile_image_url;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, assign) int statuses_count;
@property (nonatomic, assign) int favourites_count;
@property (nonatomic, assign) int followers_count;
@property (nonatomic, assign) int friends_count;
@property (nonatomic, assign) int uid;
@property (nonatomic, assign) unsigned int gender;
@property (nonatomic, assign) BOOL verified;

- (void)parseWithDic:(NSDictionary *)dic;

@end

/////////////////////////////////////////Monstea_user_info/////////////////////////////////////////
@interface Monstea_user_info : DataModelBase

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_sign;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *show;

@property (nonatomic, assign) unsigned int gender;

@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, assign) int age;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, copy) NSString *blood;

@property (nonatomic, copy) NSString *placeName;

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) double longitude;;
@property (nonatomic, assign) double latitude;

@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *login_time;
@property (nonatomic, assign) BOOL is_friend;
@property (nonatomic, assign) BOOL is_blocked;

- (void)parseWithDic:(NSDictionary *)dic;

@end

/////////////////////////////////////////AccountDTO/////////////////////////////////////////
@interface AccountDTO : DataModelBase

@property (nonatomic, strong) Monstea_user_info *monstea_user_info;
@property (nonatomic, strong) Sina_user_info *sina_user_info;
@property (nonatomic, strong) Session *session_info;

+ (id)sharedInstance;

+ (void)saveMonstea:(Monstea_user_info *)userInfo;
+ (void)saveSina:(NSDictionary *)dic;
+ (void)saveSession:(NSDictionary *)dic;
+ (void)saveUserInfo:(NSDictionary *)dic;

//clean local data
+ (void)cleanAccountDTO;

@end
