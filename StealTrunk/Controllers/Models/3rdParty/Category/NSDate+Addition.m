//
//  NSDate+Addition.m
//  StealTrunk
//
//  Created by wangyong on 13-3-25.
//  Copyright (c) 2013年 StealTrunk. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate(Addition)

+ (NSString *)getFormatTime:(NSDate *)date format:(NSString *)format
{
    NSString *time = @"";
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        time = [dateFormatter stringFromDate:date];
        if (time == nil) {
            time = @"";
        }
    } else {
        //time = [NSNull null];
        time = @"";
    }
    return time;
}

+ (NSString *)getFormatTime:(NSDate *)date
{
    return [self getFormatTime:date format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)convertTime:(NSString *)time format:(NSString *)format
{
    NSDate *time2 = nil;
    if ((NSObject *)time != [NSNull null]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        time2 = [dateFormatter dateFromString:time];
    } else {
        
    }
    return time2;
}

+ (NSDate *)convertTime:(NSString *)time
{
    return [self convertTime:time format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)convertTimeFromNumber:(NSNumber *)time
{
    NSDate *time2 = nil;
    if ((NSObject *)time != [NSNull null] && time != nil) {
        time2 = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    }
    return time2;
}

+ (NSDate *)convertTimeFromNumber2:(NSNumber *)time
{
    NSDate *time2 = nil;
    NSDate *rTime = nil;
    if ((NSObject *)time != [NSNull null] && time != nil) {
        time2 = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
        NSString *s = [self getFormatTime: time2];
        rTime = [self convertTime: s];
    }
    return rTime;
}

+ (NSString *)convertToDay:(NSDate *)date
{
    return [self getFormatTime:date format:@"yyyy-MM-dd"];
}

+ (NSNumber *)convertNumberFromTime:(NSDate *)time
{
    NSNumber *time2 = nil;
    if ((NSObject *)time != [NSNull null] && [time isKindOfClass:[NSDate class]]) {
        long long l = [time timeIntervalSince1970];
        time2 = [NSNumber numberWithDouble:l];
    } else {
        time2 = [NSNumber numberWithDouble:0];
    }
    return time2;
    
}

+ (NSString *)getDisplayTime:(NSDate *)date
{
    NSString *str = nil;
    NSTimeInterval interval = 0-[date timeIntervalSinceNow];
    if (interval > 24*60*60) {
        str = [NSString stringWithFormat:@"%d天前", (int)(interval/(24*60*60))];
    } else if (interval > 60*60) {
        str = [NSString stringWithFormat:@"%d小时前", (int)(interval/(60*60))];
    } else if (interval > 60*5) {
        str = [NSString stringWithFormat:@"%d分钟前", (int)(interval/60)];
    } else {
        str = @"刚刚";
    }
    return str;
}

+ (NSDateComponents *)getComponenet:(NSDate *)date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | kCFCalendarUnitMinute;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

//add by kevin
+ (NSString *)easyGetDisplayTime:(NSString *)timeStr
{
    return [NSDate getDisplayTime:[NSDate convertTime:timeStr]];
}

@end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

@implementation NSDate(EKB)

+ (NSString *)stringFromatWithDateStr:(NSString *)dateStr
{
    NSString *formatStr = [NSDate stringFromDate:[NSDate dateFromString:dateStr]];
    
    return formatStr;
}

+(NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:string];
    
    NSDate *bjDate = [NSDate dateWithTimeInterval:-28800 sinceDate:date];//转换为北京时间
    
    return bjDate;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    //set calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone systemTimeZone];
    [calendar setFirstWeekday:2];//这才是周一呀。。。
    
    NSDateFormatter *timeDateFormatter = [[NSDateFormatter alloc] init];
    [timeDateFormatter setCalendar:calendar];
    [timeDateFormatter setTimeZone:calendar.timeZone];
    [timeDateFormatter setDateFormat:@"HH:mm"];
    //[timeDateFormatter setDateFormat:@"ah:mm"];//显示 上午/下午
    
    NSDateFormatter *dayOfWeekDateFormatter = [[NSDateFormatter alloc] init];
    [dayOfWeekDateFormatter setCalendar:calendar];
    [dayOfWeekDateFormatter setTimeZone:calendar.timeZone];
    dayOfWeekDateFormatter.dateFormat = @"cccc";
    
    NSDateFormatter *monthDayDateFormatter = [[NSDateFormatter alloc] init];
    [monthDayDateFormatter setCalendar:calendar];
    [monthDayDateFormatter setTimeZone:calendar.timeZone];
    monthDayDateFormatter.dateFormat = @"MM-dd";
    
    NSDateFormatter *monthDayYearDateFormatter = [[NSDateFormatter alloc] init];
    [monthDayYearDateFormatter setCalendar:calendar];
    [monthDayYearDateFormatter setTimeZone:calendar.timeZone];
    monthDayYearDateFormatter.dateFormat = @"yyyy-MM-d";
    
    NSDate *today = [NSDate date];
    
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:today];
    
    
    NSString *dateLabelString;
    NSString *timeLabelString = [timeDateFormatter stringFromDate:date];
    
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
        dateLabelString = NSLocalizedString(@"今天", nil);
    } else if ((dateComponents.year == todayComponents.year) && (dateComponents.month == todayComponents.month) && (dateComponents.day == todayComponents.day - 1)) {
        dateLabelString = NSLocalizedString(@"昨天", nil);
    } else if ((dateComponents.year == todayComponents.year) && (dateComponents.weekOfYear == todayComponents.weekOfYear)) {
        dateLabelString = [dayOfWeekDateFormatter stringFromDate:date];
    } else if (dateComponents.year == todayComponents.year) {
        dateLabelString = [monthDayDateFormatter stringFromDate:date];
    } else {
        dateLabelString = [monthDayYearDateFormatter stringFromDate:date];
    }
    
    NSString *formatTimeStr = [NSString stringWithFormat:@"%@ %@",dateLabelString,timeLabelString];
    
    //xx分钟前
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day && dateComponents.hour == todayComponents.hour) {
        NSInteger dateMinute = dateComponents.minute;
        NSInteger todayMinute = todayComponents.minute;
        
        if ((todayMinute-dateMinute) != 0) {
            formatTimeStr = [NSString stringWithFormat:@"%d%@",todayMinute-dateMinute,NSLocalizedString(@"分钟前", nil)];
        }else {
            formatTimeStr = NSLocalizedString(@"刚刚", nil);
        }
    }
    
    return formatTimeStr;
}

@end

