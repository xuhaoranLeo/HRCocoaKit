//
//  CALayer+WaveLine.h
//
//  Created by 许昊然 on 16/8/24.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (WaveLine)

/**
 *  绘制波浪线
 *
 *  @param point       起点
 *  @param length      长度
 *  @param radius      半径
 *  @param scale       波浪幅度 (0,1)
 *  @param strokeColor 线颜色
 *  @param fillColor   填充色
 *  @param vertical    是否为竖线
 *  @param rightOrTop  是否为右侧或上边半圆
 *
 *  @return 图层
 */
- (CALayer *)drawWaveLineWithPoint:(CGPoint)point length:(CGFloat)length radius:(CGFloat)radius scale:(CGFloat)scale strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor isVertical:(BOOL)vertical rightOrTop:(BOOL)rightOrTop;

@end
