//
//  HRCollectionViewModel.m
//  HRCollectionViewModel
//
//  Created by 许昊然 on 2016/11/16.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRCollectionViewModel.h"

@implementation HRCollectionViewCellModel
- (instancetype)init {
    if (self = [super init]) {
        self.cellSize = CGSizeMake(50, 50);
        [self setSelectCellBlock:^(NSIndexPath *indexPath, UICollectionView *collectionView) {
        }];
    }
    return self;
}

@end

@implementation HRCollectionViewModel
- (instancetype)init {
    if (self = [super init]) {
        self.cellModelArray = [NSMutableArray array];
        self.lineSpacing = 0;
        self.interitemSpacing = 0;
        self.sectionInset = UIEdgeInsetsZero;
    }
    return self;
}
@end
