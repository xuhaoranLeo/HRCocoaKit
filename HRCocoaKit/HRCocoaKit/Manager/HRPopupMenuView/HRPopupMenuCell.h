//
//  HRPopupMenuCell.h
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/2/14.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRPopupMenuCell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;
- (void)configCellWithTitle:(NSString *)title image:(NSString *)imageName;
@end
