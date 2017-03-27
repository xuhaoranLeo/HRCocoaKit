//
//  HRWebViewManager.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/27.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HRWebViewManager.h"

@implementation HRWebViewManager
+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - HRWebViewJavaScriptDelegate
- (void)registerJavaScriptMethod:(id<WKScriptMessageHandler>)handler configuration:(WKWebViewConfiguration *)config {
    // 验证登录，发送登录用户的手机
    [config.userContentController addScriptMessageHandler:handler name:@"GetTelephoneAction"];
    // 呼叫
    [config.userContentController addScriptMessageHandler:handler name:@"CallAction"];
}

- (void)configJavaScriptActionWithContent:(WKUserContentController *)content message:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"GetTelephoneAction"]) {
        [self sendTelNum:message];
    } else if ([message.name isEqualToString:@"CallAction"]) {
        [self callAction:message];
    }
}

#pragma mark javascript call method
- (void)sendTelNum:(WKScriptMessage *)message {
    NSLog(@"获取到手机号码");
    [self.webView.webView evaluateJavaScript:[NSString stringWithFormat:@"%@(%@)", message.body, @"17712851885"] completionHandler:nil];
}

- (void)callAction:(WKScriptMessage *)message {
    NSLog(@"拨打电话：%@", message.body);
}

#pragma mark - HRWebViewConfigurationDelegate
- (void)webViewDidFinish:(HRWebViewController *)webViewController {
    NSLog(@"页面加载完成");
}

- (void)webViewPopWhenCanGoBack:(HRWebViewController *)webViewController {
    NSLog(@"存在上一级页面，此处可以配置导航栏“关闭”按钮");
}

- (NSString *)configCookie {
    return @"document.cookie = 'coooooookie'";
}

- (void)webViewControllerDidLoad:(HRWebViewController *)webViewController {
    NSLog(@"webview did load");
}

- (void)webViewControllerWillAppear:(HRWebViewController *)webViewController {
    NSLog(@"webview will appear");
}

- (void)webViewControllerWillDisappear:(HRWebViewController *)webViewController {
    NSLog(@"webview will disappear");
}

#pragma mark - private method

@end
