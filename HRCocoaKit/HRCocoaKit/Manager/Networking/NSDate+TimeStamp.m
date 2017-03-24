//
//  NSDate+TimeStamp.m
//
//  Created by 许昊然 on 16/7/6.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "NSDate+TimeStamp.h"

@implementation NSDate (TimeStamp)
+ (NSString *)getCurrentTimeStamp {
    return [NSDate getTimeStampForSecond:0];
}

+ (NSString *)getTimeStampForSecond:(float)second {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:second];
    NSTimeInterval interval = [date timeIntervalSince1970] * 1000;
    NSString *timestamp = [NSString stringWithFormat:@"%f", (double)interval];
    return [timestamp substringToIndex:10];
}
@end
