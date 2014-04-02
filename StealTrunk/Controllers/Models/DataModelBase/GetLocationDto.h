//
//  GetLocationDto.h
//  StealTrunk
//
//  Created by wangyong on 13-7-7.
//
//

#import "DataModelBase.h"

@interface GetLocationDto : DataModelBase
{
    NSString *distance;
    NSString *latitude;
    NSString *longitude;
    NSString *name;
    NSString *__weak keyword;
}

@property (nonatomic, readonly) NSString *distance;
@property (nonatomic, readonly) NSString *latitude;
@property (nonatomic, readonly) NSString *longitude;
@property (nonatomic, readonly) NSString *name;
@property (weak, nonatomic, readonly) NSString *keyword;

- (BOOL)parse2:(NSDictionary *)result;
- (BOOL)parse:(NSDictionary *)dict;
- (NSDictionary *)JSON;
@end
