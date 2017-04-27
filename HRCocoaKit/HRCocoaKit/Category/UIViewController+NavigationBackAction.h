//
//  UIViewController+NavigationBackAction.h
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/4/27.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationBackActionHandler <NSObject>
@optional
- (BOOL)navigationShouldPopAction;
@end

@interface UIViewController (NavigationBackAction) <NavigationBackActionHandler>
@end
