//
//  HRRequestManager.m
//
//  Created by 许昊然 on 16/7/3.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRRequestManager.h"
#import "HRHUDManager.h"

@interface HRRequestManager ()
@property (nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation HRRequestManager

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - request method
- (void)start:(HandleData)handle error:(ErrorInfo)errorInfo {
    if (!self.manualHUDOperation) {
        [HRHUDManager showLoadingAlert];
    }
    __weak typeof(self) weakSelf = self;
    self.task = [HRHttpRequestGenerator callRequest:self result:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            if (!weakSelf.manualHUDOperation) {
                [HRHUDManager dismissAlert];
            }
            if (handle) {
                weakSelf.responseDic = responseObject;
                BOOL result = [[NSString stringWithFormat:@"%@", responseObject[weakSelf.codeStr]] isEqualToString:self.successStr] ? YES : NO;
                handle(responseObject, result);
                if (result == NO && !self.manualHUDOperation) {
                    [HRHUDManager showBriefAlert:responseObject[weakSelf.msgStr]];
                }
            }
        } else {
            if (!self.manualHUDOperation) {
                [HRHUDManager showBriefAlert:@"网络连接失败"];
            }
            if (errorInfo) {
                errorInfo(error);
            }
        }
    }];
}

- (void)start {
    [self start:self.handle error:self.errorInfo];
}

- (void)stop {
    [self.task cancel];
}

#pragma mark - public method
- (HRRequestMethod)method {
    return HRRequestMethodGet;
}

- (NSString *)codeStr {
    return @"code";
}

- (NSString *)msgStr {
    return @"msg";
}

- (NSString *)dataStr {
    return @"data";
}

- (NSString *)successStr {
    return @"1";
}

- (NSString *)failureStr {
    return @"0";
}

- (NSString *)requestName {
    return [NSString stringWithFormat:@"%@", NSStringFromClass([self class])];
}

- (NSString *)baseUrl {
    return @"";
}

- (NSString *)pathUrl {
    return @"";
}

- (NSDictionary *)params {
    return @{};
}

- (NSDictionary *)headers {
    return @{};
}

- (NSString *)contentType {
    return @"application/json;charset=utf-8";
}

- (BOOL)requestSerializerWithHTTP {
    return _requestSerializerWithHTTP;
}

- (AFConstructingBlock)constructing {
    return nil;
}

- (BOOL)useHTTPs {
    return _useHTTPs;
}

- (float)cacheValidTime {
    return -1;
}

- (BOOL)banCache {
    return _banCache;
}

- (BOOL)manualHUDOperation {
    return _manualHUDOperation;
}

- (NSDictionary *)responseDic {
    return _responseDic;
}

- (NSString *)description {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.method) forKey:@"method"];
    [dic setValue:self.requestName forKey:@"request_name"];
    [dic setValue:self.baseUrl forKey:@"base_url"];
    [dic setValue:self.pathUrl forKey:@"path_url"];
    [dic setValue:self.params forKey:@"params"];
    [dic setValue:self.headers forKey:@"headers"];
    return [NSString stringWithFormat:@"%@", dic];
}

@end
