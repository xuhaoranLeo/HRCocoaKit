//
//  HRPopupMenuManager.m
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/2/14.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HRPopupMenuManager.h"

@interface HRPopupMenuManager ()
@property (nonatomic,strong) HRPopupMenuView *popmenuView;
@end

@implementation HRPopupMenuManager
+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (void)showPopupMenuViewWithResponseView:(UIView *)view delegate:(id<HRPopupMenuViewDelegate>)delegate {
    [[self sharedManager] showPopupMenuView:view delegate:delegate];
}

+ (void)dismiss {
    [[self sharedManager] dismiss];
}

- (void)showPopupMenuView:(UIView *)view delegate:(id<HRPopupMenuViewDelegate>)delegate {
    if (self.popmenuView) {
        [self dismiss];
    }
    self.popmenuView = [[HRPopupMenuView alloc] initWithResponseView:view delegate:delegate];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popmenuView];
    [UIView animateWithDuration:0.2f animations:^{
        self.popmenuView.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2f animations:^{
        self.popmenuView.tableView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [self.popmenuView.triangleLayer removeFromSuperlayer];
    } completion:^(BOOL finished) {
        [self.popmenuView.tableView removeFromSuperview];
        [self.popmenuView removeFromSuperview];
        self.popmenuView = nil;
    }];
}

@end
