//
//  HRHttpRequestProxy.m
//
//  Created by 许昊然 on 16/7/4.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRHttpRequestProxy.h"

static CGFloat const kTimeoutInterval = 10;

@interface HRHttpRequestProxy ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation HRHttpRequestProxy

#pragma mark - public method
+ (instancetype)sharedProxy {
    static id sharedProxy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedProxy = [[self alloc] init];
    });
    return sharedProxy;
}

+ (NSURLSessionDataTask *)callGETRequestWithURL:(NSString *)URL params:(NSDictionary *)params success:(RequestFinished)success failure:(RequestFailed)failure header:(NSDictionary *)header useHTTPs:(BOOL)useHTTPs {
    HRHttpRequestProxy *proxy = [HRHttpRequestProxy sharedProxy];
    proxy.sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval;
    if (useHTTPs) {
        proxy.sessionManager.securityPolicy = [proxy configSecurityPolicy];
    }
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [proxy.sessionManager.requestSerializer setValue:(NSString *)obj forHTTPHeaderField:(NSString *)key];
        }];
    }
    return [proxy.sessionManager GET:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}

+ (NSURLSessionDataTask *)callPOSTRequestWithURL:(NSString *)URL params:(NSDictionary *)params success:(RequestFinished)success failure:(RequestFailed)failure header:(NSDictionary *)header useHTTPs:(BOOL)useHTTPs {
    HRHttpRequestProxy *proxy = [HRHttpRequestProxy sharedProxy];
    proxy.sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval;
    if (useHTTPs) {
        proxy.sessionManager.securityPolicy = [proxy configSecurityPolicy];
    }
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [proxy.sessionManager.requestSerializer setValue:(NSString *)obj forHTTPHeaderField:(NSString *)key];
        }];
    }
    return [proxy.sessionManager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
            [task cancel];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

+ (NSURLSessionDataTask *)uploadFileWithURL:(NSString *)URL params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(RequestFinished)success failure:(RequestFailed)failure header:(NSDictionary *)header useHTTPs:(BOOL)useHTTPs {
    HRHttpRequestProxy *proxy = [HRHttpRequestProxy sharedProxy];
    proxy.sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval * 3;
    if (useHTTPs) {
        proxy.sessionManager.securityPolicy = [proxy configSecurityPolicy];
    }
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [proxy.sessionManager.requestSerializer setValue:(NSString *)obj forHTTPHeaderField:(NSString *)key];
        }];
    }
    return [proxy.sessionManager POST:URL parameters:params constructingBodyWithBlock:block progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}



#pragma mark - private method
- (AFSecurityPolicy *)configSecurityPolicy {
//    NSString *certFilePath = [[NSBundle mainBundle] pathForResource:@"ca" ofType:@"der"];
//    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
//    NSSet *certSet = [NSSet setWithObject:certData];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone withPinnedCertificates:certSet];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // 是否允许无效证书，即自建证书。
    securityPolicy.allowInvalidCertificates = YES;
    // 是否校验证书上域名与请求域名一致
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}

#pragma mark - getter
- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval;
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json", nil];
    }
    return _sessionManager;
}

@end
