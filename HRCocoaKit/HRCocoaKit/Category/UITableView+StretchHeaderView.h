//
//  UITableView+StretchHeaderView.h

//
//  Created by 许昊然 on 16/7/26.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (StretchHeaderView)
/**
 *  创建headerView
 *
 *  @param headerView 需要添加的headerView
 *  @param subView    headerView上固定的subView
 */
- (void)hr_CreateStretchHeaderView:(UIView *)headerView subView:(UIView *)subView;
/**
 *  在scrollViewDidScroll:中调用
 *
 *  @param scrollView scrollView
 */
- (void)hr_ChangeHeaderView:(UIScrollView *)scrollView;
/**
 *  在viewDidLayoutSubviews中调用
 */
- (void)hr_ResizeView;
@end
