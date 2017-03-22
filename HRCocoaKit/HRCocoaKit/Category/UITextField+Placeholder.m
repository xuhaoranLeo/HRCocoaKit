//
//  UITextField+Placeholder.m

//
//  Created by 许昊然 on 16/7/19.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "UITextField+Placeholder.h"

@implementation UITextField (Placeholder)

- (void)setPlaceholderColor:(UIColor *)color {
    NSAssert(self.placeholder, @"placeholder不能为空");
    NSMutableAttributedString *placeholder = self.attributedPlaceholder.mutableCopy ?:[[NSMutableAttributedString alloc] initWithString:self.placeholder];
    [placeholder addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.placeholder.length)];
    self.attributedPlaceholder = placeholder;
}

- (void)setPlaceholderFont:(UIFont *)font {
    NSAssert(self.placeholder, @"placeholder不能为空");
    NSMutableAttributedString *placeholder = self.attributedPlaceholder.mutableCopy ?:[[NSMutableAttributedString alloc] initWithString:self.placeholder];
    [placeholder addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.placeholder.length)];
    self.attributedPlaceholder = placeholder;
}
@end
