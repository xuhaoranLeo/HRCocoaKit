//
//  CollectionViewController.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/22.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "CollectionViewController.h"
#import "HRCollectionViewModel.h"
#import "CommonDefine.h"

@interface CollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <HRCollectionViewModel *> *sectionModelArray;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"collectionView模型";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self setupCollectionViewSectionModelArray];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionModelArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sectionModelArray objectAtIndex:section].cellModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HRCollectionViewCellModel *cellModel = [[self.sectionModelArray objectAtIndex:indexPath.section].cellModelArray objectAtIndex:indexPath.item];
    return cellModel.configCellBlock(indexPath, collectionView);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.sectionModelArray objectAtIndex:indexPath.section].cellModelArray objectAtIndex:indexPath.item].cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return [self.sectionModelArray objectAtIndex:section].sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self.sectionModelArray objectAtIndex:section].lineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self.sectionModelArray objectAtIndex:section].interitemSpacing;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    HRCollectionViewCellModel *cellModel = [[self.sectionModelArray objectAtIndex:indexPath.section].cellModelArray objectAtIndex:indexPath.item];
    cellModel.selectCellBlock(indexPath, collectionView);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [self.sectionModelArray objectAtIndex:indexPath.section].configSupplementaryView(kind, indexPath, collectionView);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [self.sectionModelArray objectAtIndex:section].headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return [self.sectionModelArray objectAtIndex:section].footerSize;
}

#pragma mark - private method
- (void)setupCollectionViewSectionModelArray {
    [self.sectionModelArray removeAllObjects];
    [self configSection1CellModel];
    [self configSection2CellModel];
    [self configSection3CellModel];
    [self.collectionView reloadData];
}

- (void)configSection1CellModel {
    HRCollectionViewModel *sectionModel = [[HRCollectionViewModel alloc] init];
    [self.sectionModelArray addObject:sectionModel];
    HRCollectionViewCellModel *cellModel = [[HRCollectionViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.cellSize = CGSizeMake(kScreenWidth, 240);
    __weak typeof(self) weakSelf = self;
    [cellModel setConfigCellBlock:^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Section1Cell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [weakSelf randomColor];
        return cell;
    }];
    [cellModel setSelectCellBlock:^(NSIndexPath *indexPath, UICollectionView *collectionView) {
        NSLog(@"section: %li, item: %li", (long)indexPath.section, (long)indexPath.item);
    }];
}

- (void)configSection2CellModel {
    HRCollectionViewModel *sectionModel = [[HRCollectionViewModel alloc] init];
    [self.sectionModelArray addObject:sectionModel];
    sectionModel.interitemSpacing = 12;
    sectionModel.lineSpacing = 12;
    sectionModel.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
    sectionModel.headerSize = CGSizeMake(kScreenWidth, 55);
    [sectionModel setConfigSupplementaryView:^UICollectionReusableView *(NSString *kind, NSIndexPath *indexPath, UICollectionView *collectionView) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Section2Header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor orangeColor];
        return header;
    }];
    CGFloat width = (kScreenWidth-12*3)/2.f;
    CGFloat height = width*150/170.f;
    __weak typeof(self) weakSelf = self;
    for (NSInteger i=0; i<9; i++) {
        HRCollectionViewCellModel *cellModel = [[HRCollectionViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.cellSize = CGSizeMake(width, height);
        [cellModel setConfigCellBlock:^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Section2Cell" forIndexPath:indexPath];
            cell.contentView.backgroundColor = [weakSelf randomColor];
            return cell;
        }];
    }
}

- (void)configSection3CellModel {
    HRCollectionViewModel *sectionModel = [[HRCollectionViewModel alloc] init];
    [self.sectionModelArray addObject:sectionModel];
    HRCollectionViewCellModel *cellModel = [[HRCollectionViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.cellSize = CGSizeMake(kScreenWidth, 150);
    __weak typeof(self) weakSelf = self;
    [cellModel setConfigCellBlock:^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Section3Cell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [weakSelf randomColor];
        return cell;
    }];
    [cellModel setSelectCellBlock:^(NSIndexPath *indexPath, UICollectionView *collectionView) {
        NSLog(@"section: %li, item: %li", (long)indexPath.section, indexPath.item);
    }];
}

- (UIColor *)randomColor {
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Section1Cell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Section2Cell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Section3Cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Section2Header"];
    }
    return _collectionView;
}

- (NSMutableArray<HRCollectionViewModel *> *)sectionModelArray {
    if (_sectionModelArray == nil) {
        _sectionModelArray = [NSMutableArray array];
    }
    return _sectionModelArray;
}

@end
