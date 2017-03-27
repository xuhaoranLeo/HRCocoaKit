//
//  HRPopupMenuView.m
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/2/14.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HRPopupMenuView.h"
#import "HRPopupMenuCell.h"
#import "HRPopupMenuManager.h"
#import "UIView+CustomLayout.h"
#import "CommonDefine.h"

static CGFloat const kTriangleHeight = 10.f;
static CGFloat const kMargin = 10.f;

@interface HRPopupMenuView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id <HRPopupMenuViewDelegate> delegate;
@property (nonatomic, assign) CGPoint startPoint;
@end

@implementation HRPopupMenuView

- (instancetype)initWithResponseView:(UIView *)view delegate:(id<HRPopupMenuViewDelegate>)delegate {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.delegate = delegate;
        CGFloat menuWidth = 130;
        if (self.delegate && [self.delegate respondsToSelector:@selector(hr_widthOfPopupMenuView:)]) {
            menuWidth = [self.delegate hr_widthOfPopupMenuView:self];
        }
        NSInteger itemCount = 1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(hr_itemCountInPopupMenuView:)]) {
            itemCount =  [self.delegate hr_itemCountInPopupMenuView:self];
        }
        CGFloat itemHeight = 50;
        if (self.delegate && [self.delegate respondsToSelector:@selector(hr_itemHeightInPopupMenuView:)]) {
            itemHeight = [self.delegate hr_itemHeightInPopupMenuView:self];
        }
        
        CGPoint centerPoint = CGPointMake(view.screenXValue+view.widthValue/2.f, view.screenYValue+view.heightValue/2.f);
        CGFloat tableViewY = view.screenYValue + view.heightValue + kTriangleHeight;
        CGFloat tableViewX = centerPoint.x - menuWidth * 0.5;
        if (tableViewX + menuWidth + kMargin > kScreenWidth) {
            tableViewX = kScreenWidth - kMargin - menuWidth;
        } else if (tableViewX < kMargin) {
            tableViewX = kMargin;
        }
        _startPoint = CGPointMake(centerPoint.x, view.screenYValue + view.heightValue + 3);
        
        self.tableView.frame = CGRectMake(tableViewX, tableViewY, menuWidth, itemHeight*itemCount);
        self.tableView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [self addSubview:self.tableView];
        
        [self drawTriangleLayer];
    }
    return self;
}

- (void)drawTriangleLayer {
    CGFloat triangleLength = kTriangleHeight * 2.0 / 1.732;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_startPoint];
    [path addLineToPoint:CGPointMake(_startPoint.x - triangleLength * 0.5, _startPoint.y + kTriangleHeight)];
    [path addLineToPoint:CGPointMake(_startPoint.x + triangleLength * 0.5, _startPoint.y + kTriangleHeight)];
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    triangleLayer.path = path.CGPath;
    triangleLayer.fillColor = self.tableView.backgroundColor.CGColor;
    triangleLayer.strokeColor = self.tableView.backgroundColor.CGColor;
    self.triangleLayer = triangleLayer;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.layer addSublayer:triangleLayer];

    });
}

#pragma mark - response action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [HRPopupMenuManager dismiss];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_itemCountInPopupMenuView:)]) {
        return [self.delegate hr_itemCountInPopupMenuView:self];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_itemHeightInPopupMenuView:)]) {
        return [self.delegate hr_itemHeightInPopupMenuView:self];
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HRPopupMenuCell *cell = [HRPopupMenuCell createCellWithTableView:tableView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_datasourceInPopupMenuView:at:)]) {
        HRPopupMenuModel *model = [self.delegate hr_datasourceInPopupMenuView:self at:indexPath.row];
        [cell configCellWithTitle:model.title image:model.imageName];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_selectItemInPopupMenuView:at:)]) {
        [self.delegate hr_selectItemInPopupMenuView:self at:indexPath.row];
        [HRPopupMenuManager dismiss];
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 2;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
