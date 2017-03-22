//
//  NSString+CustomFormat.h

//
//  Created by 许昊然 on 16/7/18.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CustomFormat)

// 迭代方法
- (NSMutableAttributedString *)changeStringColor:(NSString *)needChangeString color:(UIColor *)color font:(UIFont *)font;
- (NSMutableAttributedString *)changeStringColor:(NSString *)needChangeString color:(UIColor *)color;
- (NSMutableAttributedString *)changeStringFont:(NSString *)needChangeString font:(UIFont *)font;
- (NSMutableAttributedString *)addUnderLine:(NSString *)needChangeString;
- (NSMutableAttributedString *)addMidLine:(NSString *)needChangeString;

/**
 改变字符串格式的方法

 @param needChangeString 需要改变的一部分字符串
 @param color 颜色
 @param font 字体
 @param under 下划线
 @param mid 中划线
 @param origin 原有的格式
 @return 新的格式
 */
- (NSMutableAttributedString *)changeStringFormat:(NSString *)needChangeString color:(UIColor *)color font:(UIFont *)font underLine:(BOOL)under midLine:(BOOL)mid originalAttribute:(NSMutableAttributedString *)origin;

@end
