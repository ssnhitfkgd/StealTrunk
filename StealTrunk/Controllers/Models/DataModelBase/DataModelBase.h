//
//  DataModelBase.h
//  StealTrunk
//
//  Created by wangyong on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModelBase : NSObject <NSCopying> {
    NSString *error;
}


@property (nonatomic, strong) NSMutableDictionary *dtoResult;

- (id)init:(NSString *)dict;
- (BOOL)parse:(NSDictionary *)dict;
- (BOOL)parse2:(NSDictionary *)result;
- (NSDictionary *)JSON;

- (NSInteger)getIntValue:(NSNumber *)num;
- (float)getFloatValue:(NSNumber *)num;
- (BOOL)getBoolValue:(NSNumber *)num;
- (NSString *)getStrValue:(NSString *)str;
- (NSString *)toParam;
- (NSString *)getError;
- (double)getDoubleValue:(NSNumber *)num;

@end
