//
//  UINavigationBar+CustomColor.m

//
//  Created by 许昊然 on 16/7/18.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "UINavigationBar+CustomColor.h"
#import <objc/runtime.h>

@implementation UINavigationBar (CustomColor)

static char overlayKey;

- (UIView *)overlay {
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay {
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNavBarBackgroundColor:(UIColor *)backgroundColor {
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void)setNavBarElementsAlpha:(CGFloat)alpha {
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    // when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}

- (void)setNavBarTranslationY:(CGFloat)translationY {
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)setNavBarReset {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
