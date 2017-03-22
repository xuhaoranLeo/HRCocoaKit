//
//  HRCollectionViewModel.h
//  HRCollectionViewModel
//
//  Created by 许昊然 on 2016/11/16.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HRCollectionViewCellModel : NSObject
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, copy) UICollectionViewCell * (^configCellBlock)(NSIndexPath *indexPath, UICollectionView *collection);
@property (nonatomic, copy) void (^selectCellBlock)(NSIndexPath *indexPath, UICollectionView *collection);
@end

@interface HRCollectionViewModel : NSObject
@property (nonatomic, strong) NSMutableArray <HRCollectionViewCellModel *> *cellModelArray;
@property (nonatomic, strong) UICollectionReusableView * (^configSupplementaryView)(NSString *kind, NSIndexPath *indexPath, UICollectionView *collection);
@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, assign) CGSize footerSize;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@end


