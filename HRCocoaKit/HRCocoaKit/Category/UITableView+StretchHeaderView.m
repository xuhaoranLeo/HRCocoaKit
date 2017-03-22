//
//  UITableView+StretchHeaderView.m

//
//  Created by 许昊然 on 16/7/26.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "UITableView+StretchHeaderView.h"
#import <objc/runtime.h>

@implementation UITableView (StretchHeaderView)

static char kStretchViewKey;
static char kOriginalFrameValueKey;
static char kDefaultHeightNumberKey;
static char kDefaultOriginal;

- (UIView *)stretchView {
    return objc_getAssociatedObject(self, &kStretchViewKey);
}

- (void)setStretchView:(UIView *)stretchView {
    objc_setAssociatedObject(self, &kStretchViewKey, stretchView, OBJC_ASSOCIATION_RETAIN);
}

- (NSValue *)originalFrameValue {
    return objc_getAssociatedObject(self, &kOriginalFrameValueKey);
}

- (void)setOriginalFrameValue:(NSValue *)originalFrameValue {
    objc_setAssociatedObject(self, &kOriginalFrameValueKey, originalFrameValue, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)defaultHeightNumber {
    return objc_getAssociatedObject(self, &kDefaultHeightNumberKey);
}

- (void)setDefaultHeightNumber:(NSNumber *)defaultHeightNumber {
    objc_setAssociatedObject(self, &kDefaultHeightNumberKey, defaultHeightNumber, OBJC_ASSOCIATION_RETAIN);
}

- (NSValue *)defaultOriginal {
    return objc_getAssociatedObject(self, &kDefaultOriginal);
}

- (void)setDefaultOriginal:(NSValue *)defaultHeightNumber {
    objc_setAssociatedObject(self, &kDefaultOriginal, defaultHeightNumber, OBJC_ASSOCIATION_RETAIN);
}

- (void)hr_CreateStretchHeaderView:(UIView *)headerView subView:(UIView *)subView {
    self.stretchView = headerView;
    self.originalFrameValue = [NSValue valueWithCGRect:headerView.frame];
    self.defaultHeightNumber = [NSNumber numberWithFloat:headerView.frame.size.height];
    self.defaultOriginal = [NSValue valueWithCGPoint:headerView.frame.origin];
    UIView *emptyHeaderView = [[UIView alloc] initWithFrame:headerView.frame];
    self.tableHeaderView = emptyHeaderView;
    [self addSubview:headerView];
    [self addSubview:subView];
}

- (void)hr_ChangeHeaderView:(UIScrollView *)scrollView {
    CGRect frame = self.stretchView.frame;
    frame.size.width = self.frame.size.width;
    self.stretchView.frame = frame;
    if (scrollView.contentOffset.y < 0) {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1.f;
        CGRect originalFrame = self.originalFrameValue.CGRectValue;
        originalFrame.origin.x = -offsetY / 2.f;
        originalFrame.origin.y = -offsetY * 1.f;
        originalFrame.size.width = self.frame.size.width + offsetY;
        originalFrame.size.height = self.defaultHeightNumber.floatValue + offsetY;
        self.originalFrameValue = [NSValue valueWithCGRect:originalFrame];
        self.stretchView.frame = originalFrame;
    } else {
        CGRect frame = self.stretchView.frame;
        frame.origin = self.defaultOriginal.CGPointValue;
        frame.size.height = self.defaultHeightNumber.floatValue;
        self.stretchView.frame = frame;
    }
}

- (void)hr_ResizeView {
    CGRect originalFrame = self.originalFrameValue.CGRectValue;
    originalFrame.size.width = self.frame.size.width;
    self.originalFrameValue = [NSValue valueWithCGRect:originalFrame];
    self.stretchView.frame = originalFrame;
}

@end
