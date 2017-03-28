//
//  HRWebViewManager.h
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/27.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRWebViewController.h"

@interface HRWebViewManager : NSObject <HRWebViewJavaScriptDelegate, HRWebViewConfigurationDelegate>
+ (instancetype)sharedManager;
@property (nonatomic, weak) HRWebViewController *webView;
@end
