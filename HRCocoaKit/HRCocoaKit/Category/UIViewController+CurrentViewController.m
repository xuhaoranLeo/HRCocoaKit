//
//  UIViewController+CurrentViewController.m

//
//  Created by 许昊然 on 16/7/28.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "UIViewController+CurrentViewController.h"

@implementation UIViewController (CurrentViewController)
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isMemberOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

@end
