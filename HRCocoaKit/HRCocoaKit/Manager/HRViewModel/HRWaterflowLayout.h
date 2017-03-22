//
//  HRWaterflowLayout.h
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/2/10.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRWaterflowLayout;

@protocol HRWaterflowLayoutDelegate <NSObject>
@required
- (CGFloat)hr_waterflowLayout:(HRWaterflowLayout *)waterflowLayout heightForRowAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth;
@optional
- (CGFloat)hr_columnCountInWaterflowLayout:(HRWaterflowLayout *)waterflowLayout;
- (CGFloat)hr_interitemSpacingInWaterflowLayout:(HRWaterflowLayout *)waterflowLayout;
- (CGFloat)hr_lineSpacingInWaterflowLayout:(HRWaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)hr_edgeInsetInWaterflowLayout:(HRWaterflowLayout *)waterflowLayout;
- (CGFloat)hr_headerHeightInWaterflowLayout:(HRWaterflowLayout *)waterflowLayout;
- (CGFloat)hr_footerHeightInWaterflowLayout:(HRWaterflowLayout *)waterflowLayout;
@end

@interface HRWaterflowLayout : UICollectionViewLayout
@property (nonatomic, weak) id <HRWaterflowLayoutDelegate> delegate;
@end
