//
//  UITextField+ValidChar.h

//
//  Created by 许昊然 on 16/7/19.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ValidChar)

/**
 *  用于textField:shouldChangeCharactersInRange:replacementString代理方法中判断输入是否为数字加小数点的组合
 *
 *  @param string string
 *  @param range  range
 *  @param count  限制输入小数点后几位数
 *
 *  @return is or not
 */
- (BOOL)validateNumberDot:(NSString *)string range:(NSRange)range count:(NSInteger)count;

/**
 *  判断输入的是否为指定位数的数字
 *
 *  @param string string
 *  @param count  指定位数
 *
 *  @return is or not
 */
- (BOOL)validateNumber:(NSString*)string count:(NSInteger)count;
/**
 *  身份证格式判断
 *
 *  @param string string
 *
 *  @return is or not
 */
- (BOOL)validateIDCard:(NSString *)string;
/**
 *  过滤特殊字符
 *
 *  @param string string
 *  @param count  指定位数
 *
 *  @return is or not
 */
- (BOOL)filterSpecialCharacters:(NSString *)string count:(NSInteger)count;
@end
