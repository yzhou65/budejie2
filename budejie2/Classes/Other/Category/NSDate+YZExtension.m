//
//  NSDate+YZExtension.m
//  budejie
//
//  Created by Yue on 8/9/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "NSDate+YZExtension.h"

@implementation NSDate (YZExtension)

- (NSDateComponents *)timeElapsedFrom:(NSDate *)from
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:from toDate:self options:0];
    
    return cmps;
}

- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    return nowYear == selfYear;
}

/**
 将当前时间和self都转为yyyy－MM－dd的字符串形式，再比较是否为同一天
 */
- (BOOL)isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowDate = [fmt stringFromDate:[NSDate date]];
    NSString *selfDate = [fmt stringFromDate:self];
    
    return [nowDate isEqualToString: selfDate];
}

- (BOOL)isYesterday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

//- (BOOL)isToday
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//    return nowCmps.year == selfCmps.year && nowCmps.month == selfCmps.month && nowCmps.day == nowCmps.day;
//}



@end
