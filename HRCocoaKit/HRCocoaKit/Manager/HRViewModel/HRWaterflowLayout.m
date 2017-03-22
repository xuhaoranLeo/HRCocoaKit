//
//  HRWaterflowLayout.m
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/2/10.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HRWaterflowLayout.h"

// 默认列数
static NSInteger const kDefaultColumnCount = 2;
// 默认itemSpacing
static CGFloat const kDefaultItemSpacing = 12;
// 默认lineSpacing
static CGFloat const kDefaultLineSpacing = 12;
// 默认edgeInset
static UIEdgeInsets const kDefaultEdgeInsets = {0, 12, 0, 12};

@interface HRWaterflowLayout ()
@property (nonatomic, strong) NSMutableArray *attributeArray;
@property (nonatomic, strong) NSMutableArray *columnHeightArray;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign, readonly) NSInteger columnCount;
@property (nonatomic, assign, readonly) CGFloat itemSpacing;
@property (nonatomic, assign, readonly) CGFloat lineSpacing;
@property (nonatomic, assign, readonly) UIEdgeInsets edgeInsets;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *headerLayoutAttributes;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *footerLayoutAttributes;
@property (nonatomic, assign) CGFloat footerHeight;


@end

@implementation HRWaterflowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.contentHeight = 0;
    self.headerLayoutAttributes = nil;
    self.footerLayoutAttributes = nil;
    [self.columnHeightArray removeAllObjects];
    [self.attributeArray removeAllObjects];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_headerHeightInWaterflowLayout:)]) {
        self.headerHeight = [self.delegate hr_headerHeightInWaterflowLayout:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_footerHeightInWaterflowLayout:)]) {
        self.footerHeight = [self.delegate hr_footerHeightInWaterflowLayout:self];
    }
    for (NSInteger i=0; i<self.columnCount; i++) {
        [self.columnHeightArray addObject:@(self.edgeInsets.top+self.headerHeight)];
    }
    UICollectionViewLayoutAttributes *lastAttr = nil;
    NSInteger sectionCnt = [self.collectionView numberOfSections];
    for (NSInteger section=0; section<sectionCnt; section++) {
        NSInteger itemCnt = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item=0; item<itemCnt; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (section == sectionCnt-1 && item == itemCnt-1) {
                lastAttr = attr;
            }
            [self.attributeArray addObject:attr];
        }
    }
    if (self.headerHeight > 0) {
        self.headerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        self.headerLayoutAttributes.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, self.headerHeight);
        [self.attributeArray addObject:self.headerLayoutAttributes];
    }
    if (self.footerHeight > 0) {
        self.footerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        self.footerLayoutAttributes.frame = CGRectMake(0, self.contentHeight + self.edgeInsets.bottom, self.collectionView.frame.size.width, self.footerHeight);
        [self.attributeArray addObject:self.footerLayoutAttributes];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributeArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    return attr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    CGFloat width = (collectionViewWidth - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.itemSpacing) / self.columnCount;
    CGFloat height = [self.delegate hr_waterflowLayout:self heightForRowAtIndexPath:indexPath.item itemWidth:width];
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeightArray[0] doubleValue];
    for (NSInteger i=0; i<self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeightArray[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat x = self.edgeInsets.left + destColumn * (width + self.itemSpacing);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top + self.headerHeight) {
        y += self.lineSpacing;
    }
    
    attr.frame = CGRectMake(x, y, width, height);
    self.columnHeightArray[destColumn] = @(CGRectGetMaxY(attr.frame));
    CGFloat columnHeight = [self.columnHeightArray[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attr;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight + self.edgeInsets.bottom + self.footerHeight);
}

#pragma mark - getter
- (NSMutableArray *)attributeArray {
    if (_attributeArray == nil) {
        _attributeArray = [NSMutableArray array];
    }
    return _attributeArray;
}

- (NSMutableArray *)columnHeightArray {
    if (_columnHeightArray == nil) {
        _columnHeightArray = [NSMutableArray array];
    }
    return _columnHeightArray;
}

- (NSInteger)columnCount {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_columnCountInWaterflowLayout:)]) {
        return [self.delegate hr_columnCountInWaterflowLayout:self];
    } else {
        return kDefaultColumnCount;
    }
}

- (CGFloat)itemSpacing {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_interitemSpacingInWaterflowLayout:)]) {
        return [self.delegate hr_interitemSpacingInWaterflowLayout:self];
    } else {
        return kDefaultItemSpacing;
    }
}

- (CGFloat)lineSpacing {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_lineSpacingInWaterflowLayout:)]) {
        return [self.delegate hr_lineSpacingInWaterflowLayout:self];
    } else {
        return kDefaultLineSpacing;
    }
}

- (UIEdgeInsets)edgeInsets {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hr_edgeInsetInWaterflowLayout:)]) {
        return [self.delegate hr_edgeInsetInWaterflowLayout:self];
    } else {
        return kDefaultEdgeInsets;
    }
}

@end
