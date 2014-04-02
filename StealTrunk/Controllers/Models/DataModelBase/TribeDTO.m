//
//  TribeDTO.m
//  StealTrunk
//
//  Created by 点兄 on 13-7-20.
//
//

#import "TribeDTO.h"

@implementation TribeDTO

@synthesize tribe_id = _tribe_id;
@synthesize distance = _distance;
@synthesize tribe_name = _tribe_name;
@synthesize tribe_type = _tribe_type;
@synthesize farm_count = _farm_count;
@synthesize location = _location;
@synthesize top10_list = _top10_list;

- (BOOL)parse2:(NSDictionary *)result
{
    self.tribe_id = [self getStrValue:[result objectForKey:@"id"]];
    self.distance = [self getStrValue:[result objectForKey:@"distance"]];
    self.tribe_name = [self getStrValue:[result objectForKey:@"name"]];
    self.tribe_type = [self getStrValue:[result objectForKey:@"type"]];
    self.farm_count = [self getStrValue:[result objectForKey:@"farm_count"]];
    self.location = CLLocationCoordinate2DMake([self getDoubleValue:[result objectForKey:@"latitude"]], [self getDoubleValue:[result objectForKey:@"longitude"]]);
    
    self.top10_list = [NSMutableArray arrayWithArray:[result objectForKey:@"top10"]];
    
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
