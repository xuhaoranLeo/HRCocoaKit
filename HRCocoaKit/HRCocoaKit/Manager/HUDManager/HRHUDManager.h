//
//  HRHUDManager.h

//
//  Created by 许昊然 on 16/7/20.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRHUDManager : NSObject
/**
 *  加载中的HUD，转小菊花
 */
+ (void)showLoadingAlert;
/**
 *  一直存在的HUD，纯文字
 *
 *  @param message 提示文字
 */
+ (void)showPermanentAlert:(NSString *)message;
/**
 *  一定时间消失的HUD，纯文字
 *
 *  @param message 提示文字
 */
+ (void)showBriefAlert:(NSString *)message;
/**
 *  一定时间消失的自定义图片的HUD，图片大小为37*37
 *
 *  @param message   提示文字
 *  @param imageName 图片名称
 */
+ (void)showCustomAlert:(NSString *)message image:(NSString *)imageName;
/**
 *  将HUD消失掉
 */
+ (void)dismissAlert;
@end
