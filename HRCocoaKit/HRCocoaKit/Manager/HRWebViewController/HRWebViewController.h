//
//  HRWebViewController.h
//
//  Created by 许昊然 on 16/7/8.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class HRWebViewController;

@protocol HRWebViewConfigurationDelegate <NSObject>
@optional
- (void)webViewControllerDidLoad:(HRWebViewController *)webViewController;
- (void)webViewControllerWillAppear:(HRWebViewController *)webViewController;
- (void)webViewControllerWillDisappear:(HRWebViewController *)webViewController;
- (void)webViewDidFinish:(HRWebViewController *)webViewController message:(WKScriptMessage *)message;
- (void)webViewPopWhenCanGoBack:(HRWebViewController *)webViewController;
- (NSString *)configCookie;
@end

@protocol HRWebViewJavaScriptDelegate <NSObject>
@optional
- (void)registerJavaScriptMethod:(id <WKScriptMessageHandler>)handler configuration:(WKWebViewConfiguration *)config;
- (void)configJavaScriptActionWithContent:(WKUserContentController *)content message:(WKScriptMessage *)message;
@end

@interface HRWebViewController : UIViewController
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, weak) id <HRWebViewJavaScriptDelegate> javascript;
@property (nonatomic, weak) id <HRWebViewConfigurationDelegate> configuration;

- (instancetype)initWithConfiguration:(void(^)(HRWebViewController *))configuration;
- (void)startWithRequestUrlString:(NSString *)urlStr;
- (void)startWithRequestUrl:(NSURL *)url;
- (void)startWithHtmlString:(NSString *)htmlStr;
@end
