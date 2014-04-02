//
//  NSDate+Addition.h
//  StealTrunk
//
//  Created by wangyong on 13-3-25.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Addition)

+ (NSString *)getFormatTime:(NSDate *)date format:(NSString *)format;
+ (NSString *)getFormatTime:(NSDate *)date;
+ (NSDate *)convertTime:(NSString *)time;
+ (NSDate *)convertTime:(NSString *)time format:(NSString *)format;
+ (NSDate *)convertTimeFromNumber:(NSNumber *)time;
// 矫正时区问题
+ (NSDate *)convertTimeFromNumber2:(NSNumber *)time;
+ (NSString *)convertToDay:(NSDate *)date;
+ (NSNumber *)convertNumberFromTime:(NSDate *)time;
+ (NSString *)getDisplayTime:(NSDate *)date;
+ (NSDateComponents *)getComponenet:(NSDate *)date;

//add by kevin
+ (NSString *)easyGetDisplayTime:(NSString *)timeStr;

@end


@interface NSDate(EKB)

+ (NSDate *)dateFromString:(NSString *)string;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)stringFromatWithDateStr:(NSString *)dateStr;

@end
