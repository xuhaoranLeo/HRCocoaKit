//
//  UIView+CustomMethod.h

//
//  Created by 许昊然 on 16/7/11.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomMethod)

/**
 *  移除所有子视图
 */
- (void)removeAllSubviews;
/**
 *  取得view的controller
 *
 *  @return controller
 */
- (UIViewController *)getCurrentViewController;

@end
