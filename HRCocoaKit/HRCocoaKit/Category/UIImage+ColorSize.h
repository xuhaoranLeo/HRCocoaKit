//
//  UIImage+ColorSize.h

//
//  Created by 许昊然 on 16/7/11.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorSize)
/**
 *  返回纯色矢量图
 *
 *  @param color 颜色
 *
 *  @return 矢量图
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  返回指定大小图片
 *
 *  @param size  图片大小
 *  @param image 需压缩图片
 *
 *  @return 压缩后图片
 */
+ (UIImage *)resizeImageToSize:(CGSize)size image:(UIImage*)image;
/**
 *  在当前图片中心位置上放一张不改变大小的图片
 *
 *  @param image 上面的图片
 *  @param size  图片大小
 *
 *  @return 组合后的图片
 */
- (UIImage *)combineWithTopImage:(UIImage *)image resultImageSize:(CGSize)size;
/**
 *  在当前图片上放一张图片
 *
 *  @param image  上面的图片
 *  @param size   图片大小
 *  @param insets 顶层图片距四周位置
 *
 *  @return 组合后的图片
 */
- (UIImage *)combineWithTopImage:(UIImage *)image resultImageSize:(CGSize)size topImageLocation:(UIEdgeInsets)insets;
@end
