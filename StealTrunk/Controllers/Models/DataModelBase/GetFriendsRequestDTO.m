//
//  GetFriendsAddDTO.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-8.
//
//

#import "GetFriendsRequestDTO.h"

@implementation GetFriendsRequestDTO
@synthesize userInfo = _userInfo;

@synthesize reason = _reason;
@synthesize msg_id = _msg_id;
@synthesize is_readed = _is_readed;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)parse2:(NSDictionary *)result
{    
    self.userInfo = [[Monstea_user_info alloc] init];
    [self.userInfo parseWithDic:[result objectForKey:@"from_user"]];
    
    self.reason = [self getStrValue:[result objectForKey:@"message"]];
    self.msg_id = [self getStrValue:[result objectForKey:@"id"]];
    self.is_readed = [self getBoolValue:[result objectForKey:@"is_readed"]];
    
    return YES;
}

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    error = [[dict objectForKey:@"error"] copy];
    NSDictionary *result = [[dict objectForKey:@"data"] objectForKey:@"list"];
    if (error && [error intValue] == 0 && (NSObject *)result != [NSNull null] && result != nil) {
        [self parse2:result];
    } else {
        tf = NO;
    }
    //
    return tf;
}

@end
