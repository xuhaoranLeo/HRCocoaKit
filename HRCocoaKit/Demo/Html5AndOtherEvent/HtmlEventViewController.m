//
//  HtmlEventViewController.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/27.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HtmlEventViewController.h"
#import "HRCocoaKit.h"
#import "HREventManager.h"

@interface HtmlEventViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;
@end

@implementation HtmlEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Html事件和其他事件";
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
    HREventModel *event = [[HREventModel alloc] init];
    switch (indexPath.row) {
        case 0: {
            event.event_type = HREventTypeLink;
            event.event_link = @"https://www.baidu.com";
            [HREventManager browseEvent:event parent:self];
        }
            break;
        case 1: {
            event.event_type = HREventTypeDetail;
            [HREventManager browseEvent:event parent:self];
        }
            break;
        default:
            break;
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSArray *)dataList {
    if (_dataList == nil) {
        _dataList = @[@"纯链接跳转事件",
                      @"其他跳转事件，具体配置event_id"];
    }
    return _dataList;
}

@end
