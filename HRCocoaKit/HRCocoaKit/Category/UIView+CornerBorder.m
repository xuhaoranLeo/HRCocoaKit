//
//  UIView+CornerBorder.m
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/2/22.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "UIView+CornerBorder.h"

@implementation UIView (CornerBorder)
- (void)addBorderWithWidth:(CGFloat)width color:(UIColor *)color {
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = width;
}

- (void)addAllCornerWithRadius:(CGFloat)radius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

- (void)addSeveralCornerWithCircleSize:(CGSize)size corner:(UIRectCorner)corner viewRect:(CGRect)rect {
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:size];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

- (void)addSeveralCornerWithCircleSize:(CGSize)size corner:(UIRectCorner)corner {
    [self addSeveralCornerWithCircleSize:size corner:corner viewRect:self.frame];
}

- (void)addShadowWithOffset:(CGSize)offset amount:(CGFloat)amount color:(UIColor *)color {
    self.layer.shadowColor = (color ?: [UIColor grayColor]).CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-amount, -amount, CGRectGetWidth(self.bounds) + amount*2, CGRectGetHeight(self.bounds) + amount*2) cornerRadius:(CGRectGetHeight(self.bounds) + amount*2) / 2.0].CGPath;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = 0.5;
    self.layer.masksToBounds = NO;
}

@end
