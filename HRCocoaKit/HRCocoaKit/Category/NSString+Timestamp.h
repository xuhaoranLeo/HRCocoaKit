//
//  NSString+Timestamp.h
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/3/7.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Timestamp)
/*
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 */


/**
 返回指定格式的时间

 @param formatter 时间格式
 @return 时间字符串
 */
- (NSString *)transformTimestampWithFormatter:(NSString *)formatter;

/**
 返回周x

 @return 周x
 */
- (NSString *)transformWeekday;

/**
 返回指定格式的时间，如果一天内，返回xx小时前，如果一小时内，返回xx分钟前，如果一分钟内，返回刚刚

 @param formatter 时间格式
 @return 时间字符串
 */
- (NSString *)transformFormattedDateWithFormatter:(NSString *)formatter;


/**
 根据Date返回指定的格式

 @param date NSDate
 @param formatter 时间格式
 @return 时间字符串
 */
+ (NSString *)transformTimestampWithDate:(NSDate *)date formatter:(NSString *)formatter;
@end
