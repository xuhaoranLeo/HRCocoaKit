//
//  WaterflowViewController.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/22.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "WaterflowViewController.h"
#import "HRWaterflowLayout.h"
#import "CommonDefine.h"
@interface WaterflowViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HRWaterflowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WaterflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"waterflow模型";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaterflowCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [self randomColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"section: %li, item: %li", indexPath.section, indexPath.item);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WaterflowHeader" forIndexPath:indexPath];
    headerView.backgroundColor = [self randomColor];
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 95);
}

- (CGFloat)hr_waterflowLayout:(HRWaterflowLayout *)waterflowLayout heightForRowAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth {
    return arc4random() % 200 + 50;
}

- (UIEdgeInsets)hr_edgeInsetInWaterflowLayout:(HRWaterflowLayout *)waterflowLayout {
    return UIEdgeInsetsMake(12, 12, 12, 12);
}

- (CGFloat)hr_headerHeightInWaterflowLayout:(HRWaterflowLayout *)waterflowLayout {
    return 100;
}

#pragma mark - private method

- (UIColor *)randomColor {
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        HRWaterflowLayout *layout = [[HRWaterflowLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = kLightGrayColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"WaterflowCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WaterflowHeader"];
    }
    return _collectionView;
}

@end
