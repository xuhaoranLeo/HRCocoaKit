//
//  HRPopupMenuView.h
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/2/14.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRPopupMenuModel.h"

@class HRPopupMenuView;

@protocol HRPopupMenuViewDelegate <NSObject>
@required
- (HRPopupMenuModel *)hr_datasourceInPopupMenuView:(HRPopupMenuView *)menuView at:(NSInteger)index;
- (NSInteger)hr_itemCountInPopupMenuView:(HRPopupMenuView *)menuView;
@optional
- (CGFloat)hr_widthOfPopupMenuView:(HRPopupMenuView *)menuView;
- (CGFloat)hr_itemHeightInPopupMenuView:(HRPopupMenuView *)menuView;
- (void)hr_selectItemInPopupMenuView:(HRPopupMenuView *)menuView at:(NSInteger)index;
@end

@interface HRPopupMenuView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) CAShapeLayer *triangleLayer;
- (instancetype)initWithResponseView:(UIView *)view delegate:(id <HRPopupMenuViewDelegate>)delegate;
@end
