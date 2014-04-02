//
//  DataModelBase.m
//  StealTrunk
//
//  Created by wangyong on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataModelBase.h"
#import "JSON.h"

@implementation DataModelBase
@synthesize dtoResult = _dtoResult;

- (id)init:(NSString *)str
{
    self = [super init];
    if (self) {
        NSDictionary *dict = [str JSONValue];
        BOOL tf = [self parse:dict];
        if (tf == NO) {
            self = nil;
        }
    }
    return self;
}

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        self.dtoResult = [[NSMutableDictionary alloc] init];
//        }
//    
//    return self;
//}

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    return tf;         
}

- (BOOL)parse2:(NSDictionary *)result
{
    
    BOOL tf = YES;
    return tf;
}

- (NSDictionary *)JSON
{
    return nil;
}

- (NSInteger)getIntValue:(NSNumber *)num
{
    NSInteger n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num intValue];
    }
    return n;
}

- (float)getFloatValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num floatValue];
    }
    return n;
}

- (double)getDoubleValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num doubleValue];
    }
    return n;
}

- (BOOL)getBoolValue:(NSNumber *)num
{
    float n = 0;
    if ((NSObject *)num != [NSNull null]) {
        n = [num boolValue];
    }
    return n;
}

- (NSString *)getStrValue:(NSString *)str
{
    NSString *s = @"";
    if ((NSObject *)str != [NSNull null] && str != nil) {
        s = [NSString stringWithFormat:@"%@",str];
    }
    return s;
}

- (NSString *)toParam
{
    return @"";
}

- (NSString *)getError
{
    return error;
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone {
    DataModelBase *base = [[self class] allocWithZone: zone];
    base->error = [error copy];
    return base;
}

@end
