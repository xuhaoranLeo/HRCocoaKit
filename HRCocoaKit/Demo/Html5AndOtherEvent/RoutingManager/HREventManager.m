//
//  HREventManager.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/27.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HREventManager.h"
#import "HRWebViewManager.h"

@implementation HREventModel

@end

@implementation HREventManager
+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (void)browseEvent:(HREventModel *)event parent:(UIViewController *)parent {
    HRWebViewManager *manager = [HRWebViewManager sharedManager];
    HRWebViewController *webView = [[HRWebViewController alloc] init];
    webView.javascript = manager;
    webView.configuration = manager;
    manager.webView = webView;
    switch (event.event_type) {
        case HREventTypeLink: {
            [webView startWithRequestUrlString:event.event_link];
            [parent showViewController:webView sender:nil];
        }
            break;
        case HREventTypeDetail: {
            NSURL *path = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
            [webView startWithRequestUrl:path];
            [parent showViewController:webView sender:nil];
        }
            break;
    }
}

@end
