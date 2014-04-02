//
//  AccountDTO.m
//
//  Created by wangyong on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccountDTO.h"

/////////////////////////////////////////Session/////////////////////////////////////////
@implementation Session
@synthesize login_type = _login_type;
@synthesize token = _token;
@synthesize host = _host;

- (void)parseWithDic:(NSDictionary *)dic
{
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        self.token = [self getStrValue:[dic objectForKey:@"token"]];
        self.host = [self getStrValue:[dic objectForKey:@"host"]];
        self.login_type = @"sina";//[self getStrValue:[dic objectForKey:@"login_type"]];
    }
}

@end

/////////////////////////////////////////Sina_user_info/////////////////////////////////////////
@implementation Sina_user_info
@synthesize access_token = _access_token;
@synthesize description = _description;
@synthesize location = _location;
@synthesize profile_image_url = _profile_image_url;
@synthesize screen_name = _screen_name;
@synthesize statuses_count = _statuses_count;
@synthesize favourites_count = _favourites_count;
@synthesize followers_count = _followers_count;
@synthesize friends_count = _friends_count;
@synthesize uid = _uid;
@synthesize gender = _gender;
@synthesize verified = _verified;

- (void)parseWithDic:(NSDictionary *)dic
{
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        self.access_token = [self getStrValue:[dic objectForKey:@"access_token"]];
        self.description = [self getStrValue:[dic objectForKey:@"description"]];
        self.location = [self getStrValue:[dic objectForKey:@"location"]];
        self.profile_image_url = [self getStrValue:[dic objectForKey:@"profile_image_url"]];
        self.screen_name = [self getStrValue:[dic objectForKey:@"screen_name"]];
        
        self.statuses_count = [self getIntValue:[dic objectForKey:@"statuses_count"]];
        self.favourites_count = [self getIntValue:[dic objectForKey:@"favourites_count"]];
        self.followers_count = [self getIntValue:[dic objectForKey:@"followers_count"]];
        self.friends_count = [self getIntValue:[dic objectForKey:@"friends_count"]];
        self.uid = [self getIntValue:[dic objectForKey:@"uid"]];
        self.gender = [self getIntValue:[dic objectForKey:@"gender"]];
        
        self.verified = [self getBoolValue:[dic objectForKey:@"verified"]];
    }
}

@end

/////////////////////////////////////////Monstea_user_info/////////////////////////////////////////
@implementation Monstea_user_info

@synthesize user_id = _user_id;
@synthesize user_name = _user_name;
@synthesize user_sign = _user_sign;
@synthesize avatar = _avatar;
@synthesize birthday = _birthday;
@synthesize blood = _blood;
@synthesize photos = _photos;
@synthesize gender = _gender;
@synthesize age = _age;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize placeName = _placeName;
@synthesize show = _show;

@synthesize is_friend = _is_friend;
@synthesize is_blocked = _is_blocked;
@synthesize distance = _distance;
@synthesize login_time = _login_time;

- (id)init
{
    self = [super init];
    if (self) {
        self.longitude = 300;
        self.latitude = 300;
        self.gender = -1;
    }
    return self;
}

- (void)parseWithDic:(NSDictionary *)dic
{
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
#warning 强壮性不够
        self.user_id = [self getStrValue:[dic objectForKey:@"id"]];
        self.user_name = [self getStrValue:[dic objectForKey:@"name"]];
        self.user_sign = [self getStrValue:[dic objectForKey:@"sign_text"]];
        self.avatar = [self getStrValue:[dic objectForKey:@"avatar"]];
        self.birthday = [self getStrValue:[dic objectForKey:@"birthday"]];
        self.blood = [self getStrValue:[dic objectForKey:@"blood"]];
        self.gender = [self getIntValue: [dic objectForKey: @"gender"]];
        self.age = [self getIntValue:[dic objectForKey: @"age"]];
        self.longitude = [self getDoubleValue: [dic objectForKey: @"longitude"]];
        self.latitude  = [self getDoubleValue: [dic objectForKey: @"latitude"]];
        self.placeName = [self getStrValue: [dic objectForKey: @"place"]];
        self.show = [self getStrValue:[dic objectForKey:@"show"]];
        self.constellation = [self getStrValue:[dic objectForKey:@"sign"]];
        if (!self.constellation || [self.constellation isKindOfClass:[NSNull class]]) {
            self.constellation = NSLocalizedString(@"星座未知", nil);
        }
        
        self.distance = [self getStrValue:[dic objectForKey:@"distance"]];
        self.login_time = [self getStrValue:[dic objectForKey:@"login_time"]];
        self.is_friend = [self getBoolValue:[dic objectForKey:@"is_friend"]];
        self.is_blocked = [self getBoolValue:[dic objectForKey:@"is_blocked"]];
        
        NSArray *array = [dic objectForKey:@"photos"];
        if (array != nil) {
            self.photos = [[NSArray alloc] initWithArray:array];
        }
    }
}

/*与存储相关*/
- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_user_id forKey:@"_user_id"];
    [aCoder encodeObject:_user_name forKey:@"_user_name"];
    [aCoder encodeObject:_user_sign forKey:@"_user_sign"];
    [aCoder encodeObject:_avatar forKey:@"_avatar"];
    [aCoder encodeObject:_birthday forKey:@"_birthday"];
    [aCoder encodeObject:_constellation forKey:@"_constellation"];
    [aCoder encodeObject:_blood forKey:@"_blood"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",_gender] forKey:@"_gender"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",_age] forKey:@"_age"];
    [aCoder encodeObject:_show forKey:@"_show"];
    [aCoder encodeObject:_photos forKey:@"_photos"];
}

/*与读取相关*/
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.user_id = [aDecoder decodeObjectForKey:@"_user_id"];
        self.user_name = [aDecoder decodeObjectForKey:@"_user_name"];
        self.user_sign = [aDecoder decodeObjectForKey:@"_user_sign"];
        self.avatar = [aDecoder decodeObjectForKey:@"_avatar"];
        self.birthday = [aDecoder decodeObjectForKey:@"_birthday"];
        self.constellation = [aDecoder decodeObjectForKey:@"_constellation"];
        self.blood = [aDecoder decodeObjectForKey:@"_blood"];
        self.gender = [[aDecoder decodeObjectForKey:@"_gender"] intValue];
        self.age = [[aDecoder decodeObjectForKey:@"_age"] intValue];
        self.show = [aDecoder decodeObjectForKey:@"_show"];
        self.photos = [aDecoder decodeObjectForKey:@"_photos"];
    }
    
	return self;
}

@end

/////////////////////////////////////////AccountDTO/////////////////////////////////////////
@implementation AccountDTO
@synthesize monstea_user_info = _monstea_user_info;
@synthesize sina_user_info = _sina_user_info;
@synthesize session_info = _session_info;

static AccountDTO* _sharedInstance = nil;

+ (id)sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[AccountDTO alloc] init];
        }
    }
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.dtoResult = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - GetInfo
- (Monstea_user_info *)monstea_user_info
{
    if (!_monstea_user_info) {
        _monstea_user_info = [[Monstea_user_info alloc] init];
    }
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:MONSTEA_USER_INFO];
    if (userData) {
        _monstea_user_info = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    
    return _monstea_user_info;
}

- (Sina_user_info *)sina_user_info
{
    if (!_sina_user_info) {
        _sina_user_info = [[Sina_user_info alloc] init];
    }
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_USER_INFO];
    [_sina_user_info parseWithDic:dict];
    
    return _sina_user_info;
}

- (Session *)session_info
{
    if (!_session_info) {
        _session_info = [[Session alloc] init];
    }
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:SESSION_INFO];
    [_session_info parseWithDic:dict];
    return _session_info;
}

#pragma mark - Save To UserDefaults
+ (void)saveMonstea:(Monstea_user_info *)userInfo
{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:MONSTEA_USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveSina:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:SINA_USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveSession:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:SESSION_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveUserInfo:(NSDictionary *)dic
{
    NSDictionary *dictSection = [NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"token"],@"token", [dic objectForKey:@"host"],@"host", @"loginType",@"sina",nil];
    [AccountDTO saveSession:dictSection];

    Monstea_user_info *userInfo = [[Monstea_user_info alloc] init];
    [userInfo parseWithDic:[dic objectForKey:@"user_info"]];
    [AccountDTO saveMonstea:userInfo];
}

#pragma mark - Clear Local Data
+ (void)cleanAccountDTO
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MONSTEA_USER_INFO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_USER_INFO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SESSION_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Copy

/*
- (id)copyWithZone:(NSZone *)zone {
    AccountDTO *dto = [super copyWithZone: zone];
    dto->name = [name copy];
    dto->userID = [userID copy];
    dto->sign = [sign copy];
    dto->sign_text = [sign_text copy];
    dto->avatar = [avatar copy];
    dto->birthday = [birthday copy];
    dto->blood = [blood copy];
    dto->photos = [photos copy];
    dto->gender = gender;
    dto->age = age;
    dto->longitude = longitude;
    dto->latitude = latitude;
      return dto;
}
*/

@end
