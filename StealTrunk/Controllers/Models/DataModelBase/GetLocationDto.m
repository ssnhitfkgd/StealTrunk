//
//  GetLocationDto.m
//  StealTrunk
//
//  Created by wangyong on 13-7-7.
//
//

#import "GetLocationDto.h"

@implementation GetLocationDto
@synthesize distance;
@synthesize latitude;
@synthesize longitude;
@synthesize name;
@synthesize keyword;


- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)parse2:(NSDictionary *)result
{
    distance = [[self getStrValue:[result objectForKey:@"distance"]] copy];
    latitude = [[self getStrValue:[result objectForKey:@"latitude"]] copy];
    longitude = [[self getStrValue:[result objectForKey:@"longitude"]] copy];
    name = [[self getStrValue:[result objectForKey:@"name"]] copy];
   
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

- (NSDictionary *)JSON
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[self getStrValue:distance] forKey:@"distance"];
    [dict setObject:[self getStrValue:latitude] forKey:@"latitude"];
    [dict setObject:[self getStrValue:longitude] forKey:@"longitude"];
    [dict setObject:[self getStrValue:name] forKey:@"name"];
    return dict;
}

@end
