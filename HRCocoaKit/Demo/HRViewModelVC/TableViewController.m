//
//  TableViewController.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/22.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "TableViewController.h"
#import "HRTableViewModel.h"
#import "CommonDefine.h"
@interface TableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <HRTableViewModel *> *sectionModelArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"tableview模型";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setupTableViewSectionModelArray];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionModelArray[section].cellModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.sectionModelArray[indexPath.section].cellModelArray[indexPath.row].configCellBlock(indexPath,tableView);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.sectionModelArray[indexPath.section].cellModelArray[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.sectionModelArray[indexPath.section].cellModelArray[indexPath.row].selectCellBlock(indexPath,tableView);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.sectionModelArray[section].footerHeight;
}

#pragma mark - private method
- (void)setupTableViewSectionModelArray {
    [self.sectionModelArray removeAllObjects];
    // 此处可任意调换顺序
    [self configSection1CellModel];
    [self configSection2CellModel];
    [self configSection3CellModel];
    [self.tableView reloadData];
}

- (void)configSection1CellModel {
    HRTableViewModel *sectionModel = [[HRTableViewModel alloc] init];
    [self.sectionModelArray addObject:sectionModel];
    sectionModel.footerHeight = 15;
    HRTableViewCellModel *cellModel = [[HRTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.cellHeight= 150;
    [cellModel setConfigCellBlock:^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Section1Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Section1Cell"];
        }
        cell.textLabel.text = @"这是Section0";
        return cell;
    }];
    [cellModel setSelectCellBlock:^(NSIndexPath *indexPath, UITableView *tableView) {
        NSLog(@"section: %li, row: %li", (long)indexPath.section, (long)indexPath.row);
    }];
}

- (void)configSection2CellModel {
    HRTableViewModel *sectionModel = [[HRTableViewModel alloc] init];
    [self.sectionModelArray addObject:sectionModel];
    sectionModel.footerHeight = 15;
    for (NSInteger i=0; i<5; i++) {
        HRTableViewCellModel *cellModel = [[HRTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.cellHeight= 50;
        [cellModel setConfigCellBlock:^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Section2Cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Section2Cell"];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"section: %li, row: %li", (long)indexPath.section, (long)indexPath.row];
            return cell;
        }];
        [cellModel setSelectCellBlock:^(NSIndexPath *indexPath, UITableView *tableView) {
            NSLog(@"section: %li, row: %li", (long)indexPath.section, (long)indexPath.row);
        }];
    }
}

- (void)configSection3CellModel {
    HRTableViewModel *sectionModel = [[HRTableViewModel alloc] init];
    [self.sectionModelArray addObject:sectionModel];
    sectionModel.footerHeight = 15;
    HRTableViewCellModel *cellModel = [[HRTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.cellHeight= 100;
    [cellModel setConfigCellBlock:^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Section1Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Section1Cell"];
        }
        cell.textLabel.text = @"这是Section2";
        cell.contentView.backgroundColor = [UIColor orangeColor];
        return cell;
    }];
    [cellModel setSelectCellBlock:^(NSIndexPath *indexPath, UITableView *tableView) {
        NSLog(@"section: %li, row: %li", (long)indexPath.section, (long)indexPath.row);
    }];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray<HRTableViewModel *> *)sectionModelArray {
    if (!_sectionModelArray) {
        _sectionModelArray = [NSMutableArray array];
    }
    return _sectionModelArray;
}

@end
