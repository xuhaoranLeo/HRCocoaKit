//
//  PopupMenuViewController.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/24.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "PopupMenuViewController.h"
#import "HRCocoaKit.h"

@interface PopupMenuViewController () <HRPopupMenuViewDelegate>
@property (nonatomic, strong) NSMutableArray *listDatasource; // 弹出框选项
@end

@implementation PopupMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下拉弹窗";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - HRPopupMenuViewDelegate
- (HRPopupMenuModel *)hr_datasourceInPopupMenuView:(HRPopupMenuView *)menuView at:(NSInteger)index {
    return [self.listDatasource objectAtIndex:index];
}

- (NSInteger)hr_itemCountInPopupMenuView:(HRPopupMenuView *)menuView {
    return self.listDatasource.count;
}

- (void)hr_selectItemInPopupMenuView:(HRPopupMenuView *)menuView at:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"选项1");
            break;
        case 1:
            NSLog(@"选项2");
            break;
        case 2:
            NSLog(@"选项3");
            break;
        default:
            break;
    }
}

- (IBAction)popupMenuAction:(id)sender {
    [HRPopupMenuManager showPopupMenuViewWithResponseView:(UIButton *)sender delegate:self];
}

#pragma mark - getter
- (NSMutableArray *)listDatasource {
    if (_listDatasource == nil) {
        _listDatasource = [NSMutableArray array];
        NSArray *nameArr = @[@"选项1", @"选项2", @"选项3"];
        for (NSString *name in nameArr) {
            HRPopupMenuModel *model = [[HRPopupMenuModel alloc] init];
            model.title = name;
            [_listDatasource addObject:model];
        }
    }
    return _listDatasource;
}

@end
