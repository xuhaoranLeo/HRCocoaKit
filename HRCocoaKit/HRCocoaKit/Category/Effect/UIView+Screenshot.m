//
//  UIView+Screenshot.m

//
//  Created by 许昊然 on 16/7/26.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)
- (UIImage *)captureImageFromView {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
