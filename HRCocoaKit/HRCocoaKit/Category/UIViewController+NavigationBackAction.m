//
//  UIViewController+NavigationBackAction.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/4/27.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "UIViewController+NavigationBackAction.h"

@implementation UIViewController (NavigationBackAction)

@end

@implementation UINavigationController (ShouldPopOnBackButton)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopAction)]) {
        shouldPop = [vc navigationShouldPopAction];
    }
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}
@end
