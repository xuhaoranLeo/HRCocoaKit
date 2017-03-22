//
//  UIImageView+BlurEffects.h

//
//  Created by 许昊然 on 16/7/26.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (BlurEffects)
- (void)blurWithDefaultStyle:(CGRect)frame;
- (void)blur:(CGRect)frame style:(UIBlurEffectStyle)style;
@end
