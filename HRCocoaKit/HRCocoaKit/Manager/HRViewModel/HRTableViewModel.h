//
//  HRTableViewModel.h
//  TaoFang
//
//  Created by xuhaoran on 16/6/2.
//  Copyright © 2016年 House365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HRTableViewCellModel : NSObject
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) UITableViewCell * (^configCellBlock)(NSIndexPath *indexPath, UITableView *tableView);
@property (nonatomic, copy) void (^selectCellBlock)(NSIndexPath *indexPath, UITableView *tableView);
/*
 其他属性按需求添加
 */
@end

@interface HRTableViewModel : NSObject
@property (nonatomic, strong) NSMutableArray <HRTableViewCellModel *> *cellModelArray;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSString *footerTitle;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@end
