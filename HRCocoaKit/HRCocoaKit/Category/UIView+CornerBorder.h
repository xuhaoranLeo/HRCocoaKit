//
//  UIView+CornerBorder.h
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/2/22.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerBorder)

/**
 添加边框

 @param width 宽度
 @param color 颜色
 */
- (void)addBorderWithWidth:(CGFloat)width color:(UIColor *)color;


/**
 添加圆角

 @param radius 半径
 */
- (void)addAllCornerWithRadius:(CGFloat)radius;


/**
 添加部分圆角，此方法要考虑autolayout导致的大小问题

 @param size 圆角大小
 @param corner 需要的角 
 */
- (void)addSeveralCornerWithCircleSize:(CGSize)size corner:(UIRectCorner)corner;


/**
 添加部分圆角

 @param size 圆角大小
 @param corner 需要的角
 @param rect 视图真实大小
 */
- (void)addSeveralCornerWithCircleSize:(CGSize)size corner:(UIRectCorner)corner viewRect:(CGRect)rect;


/**
 添加阴影效果

 @param offset 偏移量 (+,+) 为左下角
 @param amount 阴影模糊度，传-1为默认值5
 @param color 阴影颜色 传nil为grayColor
 */
- (void)addShadowWithOffset:(CGSize)offset amount:(CGFloat)amount color:(UIColor *)color;

@end
