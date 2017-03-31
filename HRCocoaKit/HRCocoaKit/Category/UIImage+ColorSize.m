//
//  UIImage+ColorSize.m

//
//  Created by 许昊然 on 16/7/11.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "UIImage+ColorSize.h"

@implementation UIImage (ColorSize)

+ (UIImage *)imageWithColor:(UIColor *)color {
    // 开启基于位图的图形上下文 NO为不透明
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), NO, 0.0);
    // 绘制color颜色的矩形框
    [color setFill]; // color作为填充色
    UIRectFill(CGRectMake(0, 0, 10, 10));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)resizeImageToSize:(CGSize)size image:(UIImage *)image {
    // 建立上下文
    UIGraphicsBeginImageContext(size);
    // 获取上下文内容
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    // 重绘image
    CGContextDrawImage(ctx,CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
    // 根据指定的size大小得到新的image
    UIImage* scaled= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    ctx = nil;
    CGContextRelease(ctx);
    return scaled;
}

- (UIImage *)combineWithTopImage:(UIImage *)image resultImageSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    CGRect frame = CGRectMake(size.width/2.f-image.size.width/2.f, size.height/2.f-image.size.height/2.f, image.size.width, image.size.height);
    [image drawInRect:frame];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)combineWithTopImage:(UIImage *)image resultImageSize:(CGSize)size topImageLocation:(UIEdgeInsets)insets {
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    CGRect frame = CGRectMake(insets.left, insets.top, size.width-insets.left-insets.right, size.height-insets.top-insets.bottom);
    [image drawInRect:frame];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
@end
