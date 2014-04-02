//
//  MessageDTO.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-14.
//
//

#import "MessageDTO.h"

@implementation MessageDTO

@synthesize message_id = _message_id;
@synthesize message_type = _message_type;
@synthesize create_time = _create_time;
@synthesize is_readed = _is_readed;

@synthesize userInfo = _userInfo;


- (BOOL)parse2:(NSDictionary *)result
{
    self.message_id = [self getStrValue:[result objectForKey:@"id"]];
    self.message_type = [self getStrValue:[result objectForKey:@"type"]];
    self.create_time = [self getStrValue:[result objectForKey:@"create_time"]];
    self.is_readed = [self getBoolValue:[result objectForKey:@"is_readed"]];
    
    self.userInfo = [[Monstea_user_info alloc] init];
    [self.userInfo parseWithDic:[result objectForKey:@"from_user"]];
    
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
