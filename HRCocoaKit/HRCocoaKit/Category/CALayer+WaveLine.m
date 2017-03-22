//
//  CALayer+WaveLine.m
//
//  Created by 许昊然 on 16/8/24.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "CALayer+WaveLine.h"

@implementation CALayer (WaveLine)

- (CALayer *)drawWaveLineWithPoint:(CGPoint)point length:(CGFloat)length radius:(CGFloat)radius scale:(CGFloat)scale strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor isVertical:(BOOL)vertical rightOrTop:(BOOL)rightOrTop  {
    CGFloat circle = 2 * pow((1-scale)*(1+scale)*radius*radius, 0.5);
    CGFloat as;
    if (vertical) {
        as = acos(scale)/M_PI;
    } else {
        as = asin(scale)/M_PI;
    }
    CGPoint center;
    if (vertical) {
        if (rightOrTop) {
            center = CGPointMake(point.x-scale*radius, point.y+circle/2);
        } else {
            center = CGPointMake(point.x+scale*radius, point.y+circle/2);
        }
    } else {
        if (rightOrTop) {
            center = CGPointMake(point.x+circle/2, point.y+scale*radius);
        } else {
            center = CGPointMake(point.x+circle/2, point.y-scale*radius);
        }
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:point];
    for (NSInteger i=0; i<length/circle; i++) {
        if (vertical) {
            if (rightOrTop) {
                [bezierPath addArcWithCenter:CGPointMake(center.x, center.y+circle*i) radius:radius startAngle:M_PI*(2-as) endAngle:M_PI*as clockwise:YES];
            } else {
                [bezierPath addArcWithCenter:CGPointMake(center.x, center.y+circle*i) radius:radius startAngle:M_PI*(1+as) endAngle:M_PI*(1-as) clockwise:NO];
            }
        } else {
            if (rightOrTop) {
                [bezierPath addArcWithCenter:CGPointMake(center.x+circle*i, center.y) radius:radius startAngle:M_PI*(1+as) endAngle:M_PI*(2-as) clockwise:YES];
            } else {
                [bezierPath addArcWithCenter:CGPointMake(center.x+circle*i, center.y) radius:radius startAngle:M_PI*(1-as) endAngle:M_PI*as clockwise:NO];
            }
        }
        
    }
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.strokeColor = strokeColor.CGColor;
    return shapeLayer;
}

@end
