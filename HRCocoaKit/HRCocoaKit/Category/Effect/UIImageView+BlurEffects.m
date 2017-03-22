//
//  UIImageView+BlurEffects.m

//
//  Created by 许昊然 on 16/7/26.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "UIImageView+BlurEffects.h"

@implementation UIImageView (BlurEffects)

- (void)blurWithDefaultStyle:(CGRect)frame {
    [self blur:frame style:UIBlurEffectStyleLight];
}

- (void)blur:(CGRect)frame style:(UIBlurEffectStyle)style {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    [self addSubview:effectView];
}

@end
