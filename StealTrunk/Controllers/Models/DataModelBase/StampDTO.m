//
//  StampDTO.m
//  StealTrunk
//
//  Created by 点兄 on 13-8-8.
//
//

#import "StampDTO.h"

@implementation StampDTO

@synthesize userInfo = _userInfo;
@synthesize comment_to_id = _comment_to_id;
@synthesize create_time = _create_time;
@synthesize like_type = _like_type;
@synthesize stampID = _stampID;

- (BOOL)parse2:(NSDictionary *)result
{
    self.stampID = [self getStrValue:[result objectForKey:@"id"]];
    self.like_type = [self getStrValue:[result objectForKey:@"like_type"]];
    self.create_time = [self getStrValue:[result objectForKey:@"create_time"]];
    self.comment_to_id = [self getStrValue:[result objectForKey:@"comment_to_id"]];
    
    self.userInfo = [[Monstea_user_info alloc] init];
    [self.userInfo parseWithDic:[result objectForKey:@"owner"]];
    
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
