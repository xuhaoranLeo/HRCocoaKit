//
//  NSString+Timestamp.m
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/3/7.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "NSString+Timestamp.h"

@implementation NSString (Timestamp)
- (NSString *)transformTimestampWithFormatter:(NSString *)formatter {
    NSString *timeStr = self;
    if (timeStr.length < 10) {
        return @"暂无";
    }
    timeStr = [timeStr substringToIndex:10];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:detailDate];
}

- (NSString *)transformWeekday {
    NSString *timeStr = self;
    if (timeStr.length < 10) {
        return @"暂无";
    }
    timeStr = [timeStr substringToIndex:10];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:detailDate];
    NSInteger weekday = [weekdayComponents weekday];
    NSString *weekStr;
    switch (weekday) {
        case 1:
            weekStr = @"周日";
            break;
        case 2:
            weekStr = @"周一";
            break;
        case 3:
            weekStr = @"周二";
            break;
        case 4:
            weekStr = @"周三";
            break;
        case 5:
            weekStr = @"周四";
            break;
        case 6:
            weekStr = @"周五";
            break;
        case 7:
            weekStr = @"周六";
            break;
        default:
            break;
    }
    return weekStr;
}

- (NSString *)transformFormattedDateWithFormatter:(NSString *)formatter {
    NSString *timestampStr = self;
    if (timestampStr.length < 10) {
        return @"暂无";
    }
    timestampStr = [timestampStr substringToIndex:10];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestampStr doubleValue]];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:date];
    NSUInteger tt = 0;
    NSString *timeStr = nil;
    if(interval >= 60*60*24) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatter];
        timeStr = [dateFormatter stringFromDate:date];
    } else if (interval >= 60* 60) {
        tt = interval/3600;
        timeStr = [NSString stringWithFormat:@"%lu小时前", tt];
    } else if (interval >= 60 && interval < 60*60) {
        tt = interval/60;
        timeStr = [NSString stringWithFormat:@"%lu分钟前", tt];
    }
    else if (interval < 60 ) {
        timeStr = @"刚刚";
    }
    return timeStr;
}

+ (NSString *)transformTimestampWithDate:(NSDate *)date formatter:(NSString *)formatter {
    NSString *timeStamp = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    return [timeStamp transformTimestampWithFormatter:formatter];
}

@end
