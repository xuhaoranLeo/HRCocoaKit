//
//  HRPopupMenuManager.h
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/2/14.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRPopupMenuView.h"

@interface HRPopupMenuManager : NSObject
+ (void)showPopupMenuViewWithResponseView:(UIView *)view delegate:(id <HRPopupMenuViewDelegate>)delegate;
+ (void)dismiss;
@end
