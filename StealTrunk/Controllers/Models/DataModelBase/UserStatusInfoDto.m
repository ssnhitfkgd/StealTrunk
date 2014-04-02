//
//  FriendInfoDto.m
//  StealTrunk
//
//  Created by wangyong on 13-7-3.
//
//

#import "UserStatusInfoDto.h"

@implementation UserStatusInfoDto
@synthesize status_audio;
@synthesize status_create_time;
@synthesize status_like_count;
@synthesize status_comment_count;
@synthesize status_content;
@synthesize status_id;

@synthesize userInfo = _userInfo;


- (id)init
{
    self = [super init];
    if (self) {
        //        [self initValues];
    }
    return self;
}

- (BOOL)parse2:(NSDictionary *)result
{
    self.dtoResult = (id)result;
    status_id = [[self getStrValue:[result objectForKey:@"id"]] copy];
    status_audio = [[self getStrValue:[result objectForKey:@"audio"]] copy];
    status_content = [[self getStrValue:[result objectForKey:@"content"]] copy];
    status_like_count = [self getIntValue:[result objectForKey:@"like_count"]];
    status_comment_count = [self getIntValue:[result objectForKey:@"comment_count"]];
    NSObject *dict = [result objectForKey:@"create_time"];
    if ([dict isKindOfClass:[NSNumber class]] == YES) {
        // since 1970
        status_create_time = [NSDate convertTimeFromNumber2:(NSNumber *)dict];
    } else if ([dict isKindOfClass:[NSString class]] == YES) {
        // 2012-12-21
        status_create_time = [NSDate convertTime:(NSString *)dict];
    }
 
    
    id obj = [result objectForKey:@"owner"];
    if(obj && [obj isKindOfClass:[NSDictionary class]])
    {
        self.userInfo = [[Monstea_user_info alloc] init];
        [self.userInfo parseWithDic:obj];
    }
    return YES;
}

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    error = [[dict objectForKey:@"error"] copy];
    NSDictionary *result = [dict objectForKey:@"data"];
    if (error && [error intValue] == 0 && (NSObject *)result != [NSNull null] && result != nil) {
        [self parse2:result];
    } else {
        tf = NO;
    }
    //
    return tf;
}

@end
