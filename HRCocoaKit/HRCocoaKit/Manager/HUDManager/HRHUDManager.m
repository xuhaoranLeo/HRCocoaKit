//
//  HRHUDManager.m

//
//  Created by 许昊然 on 16/7/20.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRHUDManager.h"
#import "MBProgressHUD.h"

static NSString * const kLoadingMessage = @"加载中";
static CGFloat const kHUDShowTime = 2.5f;

@interface HRHUDManager () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIView *hudAddedView;
@end

@implementation HRHUDManager

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - default method
+ (void)showLoadingAlert {
    [HRHUDManager showLoadingAlertInView:nil];
}

+ (void)showPermanentAlert:(NSString *)message {
    [HRHUDManager showPermanentAlert:message InView:nil];
}

+ (void)showBriefAlert:(NSString *)message {
    [HRHUDManager showBriefAlert:message InView:nil];
}

+ (void)showCustomAlert:(NSString *)message image:(NSString *)imageName {
    [HRHUDManager showCustomAlert:message image:imageName InView:nil];
}

#pragma mark - in view method
+ (void)showLoadingAlertInView:(UIView *)view {
    [HRHUDManager dismissAlert];
    if (view == nil) {
        if ([[UIApplication sharedApplication].windows.lastObject isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
            view = [[UIApplication sharedApplication].windows objectAtIndex:[UIApplication sharedApplication].windows.count-2];
        } else {
            view = [UIApplication sharedApplication].windows.lastObject;
        }
    }
    [HRHUDManager sharedManager].hudAddedView = view;
    [[HRHUDManager sharedManager] addGestureInView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = kLoadingMessage;
    hud.margin = 10.f;
}

+ (void)showPermanentAlert:(NSString *)message InView:(UIView *)view {
    [HRHUDManager dismissAlert];
    if (view == nil) {
        if ([[UIApplication sharedApplication].windows.lastObject isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
            view = [[UIApplication sharedApplication].windows objectAtIndex:[UIApplication sharedApplication].windows.count-2];
        } else {
            view = [UIApplication sharedApplication].windows.lastObject;
        }
    }
    [HRHUDManager sharedManager].hudAddedView = view;
    [[HRHUDManager sharedManager] addGestureInView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
}

+ (void)showBriefAlert:(NSString *)message InView:(UIView *)view {
    [HRHUDManager dismissAlert];
    if (view == nil) {
        if ([[UIApplication sharedApplication].windows.lastObject isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
            view = [[UIApplication sharedApplication].windows objectAtIndex:[UIApplication sharedApplication].windows.count-2];
        } else {
            view = [UIApplication sharedApplication].windows.lastObject;
        }
    }
    [HRHUDManager sharedManager].hudAddedView = view;
    [[HRHUDManager sharedManager] addGestureInView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    [hud hideAnimated:YES afterDelay:kHUDShowTime];
}

+ (void)showCustomAlert:(NSString *)message image:(NSString *)imageName InView:(UIView *)view {
    [HRHUDManager dismissAlert];
    if (view == nil) {
        if ([[UIApplication sharedApplication].windows.lastObject isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
            view = [[UIApplication sharedApplication].windows objectAtIndex:[UIApplication sharedApplication].windows.count-2];
        } else {
            view = [UIApplication sharedApplication].windows.lastObject;
        }
    }
    [HRHUDManager sharedManager].hudAddedView = view;
    [[HRHUDManager sharedManager] addGestureInView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 10.f;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = CGRectMake(0, 0, 37, 37);
    hud.customView = imageView;
    [hud hideAnimated:YES afterDelay:kHUDShowTime];
}

#pragma mark - dismiss method
+ (void)dismissAlert {
    for (UIView *subView in [HRHUDManager sharedManager].hudAddedView.subviews) {
        if ([subView isKindOfClass:[MBProgressHUD class]]) {
            [(MBProgressHUD *)subView hideAnimated:NO];
        }
    }
}

#pragma mark - tap gesture
- (void)addGestureInView:(UIView *)view {
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenClick)];
    self.tap.delegate = self;
    [view addGestureRecognizer:self.tap];
}

- (void)screenClick {
    [self.tap removeTarget:nil action:nil];
    [HRHUDManager dismissAlert];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[MBBackgroundView class]]) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

@end
