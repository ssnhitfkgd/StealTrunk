//
//  RecommentDTO.m
//  lebo
//
//  Created by King on 13-4-24.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "RecommentDTO.h"

@implementation RecommentDTO

@synthesize userInfo;
@synthesize attended;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)parse2:(NSDictionary *)result
{
    BOOL tf = YES;
    
    self.userInfo = [[Monstea_user_info alloc] init];
    [self.userInfo parseWithDic:result];
    
    attended = [self getIntValue: [result objectForKey: @"attended"]];
    
    return tf;
}

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    error = [[dict objectForKey:@"error"] copy];
    NSDictionary *result = [dict objectForKey:@"result"];
    if (error && [error intValue] == 0&& (NSObject *)result != [NSNull null] && result != nil) {
        [self parse2:result];
    } else {
        tf = NO;
    }
    //
    return tf;
}

- (NSDictionary *)JSON
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //
    [dict setObject:[NSNumber numberWithInt: attended] forKey:@"attended"];
    //
    return dict;
}

@end
