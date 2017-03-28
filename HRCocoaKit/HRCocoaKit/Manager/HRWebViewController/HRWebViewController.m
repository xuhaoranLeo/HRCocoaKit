//
//  HRWebViewController.m
//
//  Created by 许昊然 on 16/7/8.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRWebViewController.h"
#import "HRHUDManager.h"
#import "CommonDefine.h"
#import "Masonry.h"

/*
 此处为防止addScriptMessageHandler引起的循环引用，也可以在viewWillDisappear中调用removeScriptMessageHandlerForName移除handler
 */

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
@end
@implementation WeakScriptMessageDelegate
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}
@end


@interface HRWebViewController () <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UILabel *reloadLabel;
@property (nonatomic, copy) void (^configurationBlock)();
@property (nonatomic, strong) WKScriptMessage *message;
@end

@implementation HRWebViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.configurationBlock) {
        self.configurationBlock(self);
    }
    if (self.configuration && [self.configuration respondsToSelector:@selector(webViewControllerDidLoad:)]) {
        [self.configuration webViewControllerDidLoad:self];
    }
    [self.view addSubview:self.webView];
    [self.webView addSubview:self.progress];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    if (self.configuration && [self.configuration respondsToSelector:@selector(webViewControllerWillAppear:)]) {
        [self.configuration webViewControllerWillAppear:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.configuration && [self.configuration respondsToSelector:@selector(webViewControllerWillDisappear:)]) {
        [self.configuration webViewControllerWillDisappear:self];
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.webView.scrollView.delegate = nil;
}

#pragma mark - public init method
- (instancetype)initWithConfiguration:(void (^)(HRWebViewController *))configuration {
    self = [super init];
    if (self) {
        self.configurationBlock = configuration;
    }
    return self;
}

- (void)startWithRequestUrlString:(NSString *)urlStr {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (void)startWithRequestUrl:(NSURL *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)startWithHtmlString:(NSString *)htmlStr {
    [self.webView loadHTMLString:htmlStr baseURL:nil];
}

#pragma mark - delegate
#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // JS交互内容
    if (self.javascript && [self.javascript respondsToSelector:@selector(configJavaScriptActionWithContent:message:)]) {
        [self.javascript configJavaScriptActionWithContent:userContentController message:message];
    }
    self.message = message;
}

#pragma mark WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return self.webView;
}

- (void)webViewDidClose:(WKWebView *)webView {
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // web alert
    [HRHUDManager showBriefAlert:message];
    completionHandler();
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"%@", navigationAction.request.URL);
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        // 拦截链接
        HRWebViewController *svc = [[HRWebViewController alloc] initWithConfiguration:self.configurationBlock];
        svc.javascript = self.javascript;
        svc.configuration = self.configuration;
        [self showViewController:svc sender:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.configuration && [self.configuration respondsToSelector:@selector(webViewDidFinish:message:)]) {
        [self.configuration webViewDidFinish:self message:self.message];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    // https
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < -30) {
        self.reloadLabel.hidden = NO;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < -20) {
        [self.webView reload];
        self.reloadLabel.hidden = YES;
    }
}

#pragma mark - response action
- (void)backAction {
    // 判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        // 如果有则返回
        [self.webView goBack];
        if (self.configuration && [self.configuration respondsToSelector:@selector(webViewPopWhenCanGoBack:)]) {
            [self.configuration webViewPopWhenCanGoBack:self];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)navLeftItemAction:(UIButton *)button {
    if (button.tag == 1) {
        [self backAction];
    } else if (button.tag == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - private method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        self.progress.hidden = YES;
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progress.hidden = NO;
        [self.progress setProgress:self.webView.estimatedProgress animated:YES];
    }
}

#pragma mark - getter
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 12;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // 写入cookie
        WKUserContentController *userContent = [[WKUserContentController alloc] init];
        NSString *cookieStr = nil;
        if (self.configuration && [self.configuration respondsToSelector:@selector(configCookie)]) {
            cookieStr = [self.configuration configCookie];
        }
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContent addUserScript:cookieScript];
        config.userContentController = userContent;
        // 注入JS调用本地的方法
        if (self.javascript && [self.javascript respondsToSelector:@selector(registerJavaScriptMethod:configuration:)]) {
            [self.javascript registerJavaScriptMethod:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] configuration:config];
        }

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        // observe
        [_webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (UIProgressView *)progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progress.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
        _progress.trackTintColor = [UIColor whiteColor];
        _progress.progressTintColor = [UIColor lightGrayColor];
    }
    return _progress;
}

- (UILabel *)reloadLabel {
    if (_reloadLabel == nil) {
        _reloadLabel = [[UILabel alloc] init];
        [self.webView.scrollView addSubview:_reloadLabel];
        [_reloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(@(0));
            make.bottom.mas_equalTo(self.webView.scrollView.mas_top).offset(-20);
            make.width.mas_greaterThanOrEqualTo(@(30));
            make.height.mas_equalTo(@(20));
        }];
        _reloadLabel.text = @"松开来重新加载页面";
        _reloadLabel.font = [UIFont systemFontOfSize:kStandardFont(14)];
        _reloadLabel.textColor = kHexRGB(0x9d9d9d);
        _reloadLabel.textAlignment = NSTextAlignmentCenter;
        _reloadLabel.hidden = YES;
    }
    return _reloadLabel;
}

@end
