//
//  NSDate+TimeStamp.h
//
//  Created by 许昊然 on 16/7/6.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeStamp)
+ (NSString *)getCurrentTimeStamp;
+ (NSString *)getTimeStampForSecond:(float)second;
@end
