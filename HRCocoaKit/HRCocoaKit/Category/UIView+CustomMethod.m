//
//  UIView+CustomMethod.m

//
//  Created by 许昊然 on 16/7/11.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "UIView+CustomMethod.h"

@implementation UIView (CustomMethod)

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (UIViewController *)getCurrentViewController {
    UIResponder *responder = self;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
        
    } while (responder);
    NSLog(@"并没有控制器");
    return nil;
}

@end
