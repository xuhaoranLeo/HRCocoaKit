//
//  HomeViewController.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/22.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HomeViewController.h"
#import "CommonDefine.h"
#import "StorageViewController.h"
#import "CollectionViewController.h"
#import "TableViewController.h"
#import "WaterFlowViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeCell"];
    }
    cell.textLabel.text = [self.dataList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            StorageViewController *svc = [StorageViewController new];
            [self showViewController:svc sender:nil];
        }
            break;
        case 1: {
            TableViewController *svc = [TableViewController new];
            [self showViewController:svc sender:nil];
        }
            break;
        case 2: {
            CollectionViewController *svc = [CollectionViewController new];
            [self showViewController:svc sender:nil];
        }
            break;
        case 3: {
            WaterFlowViewController *svc = [WaterFlowViewController new];
            [self showViewController:svc sender:nil];
        }
            break;
        default:
            break;
    }
}


#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)dataList {
    if (_dataList == nil) {
        _dataList = @[@"本地存储-HRStorageManager",
                      @"tableview模型-HRTableViewModel",
                      @"collectionView模型-HRCollectionViewModel",
                      @"waterflow模型-HRWaterflowLayout"];
    }
    return _dataList;
}

@end
