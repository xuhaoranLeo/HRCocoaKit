//
//  HRHttpRequestGenerator.m
//
//  Created by 许昊然 on 16/7/4.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRHttpRequestGenerator.h"
#import "HRRequestCacheManager.h"
#import "HRRequestManager.h"

@implementation HRHttpRequestGenerator

#pragma mark - public method
+ (instancetype)sharedGenerator {
    static id sharedGenerator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGenerator = [[self alloc] init];
    });
    return sharedGenerator;
}

+ (NSURLSessionDataTask *)callRequest:(HRRequestManager *)manager result:(HRRequestResult)result {
    HRHttpRequestGenerator *generator = [HRHttpRequestGenerator sharedGenerator];
    // cache
    if (manager.cacheValidTime > 0 && !manager.banCache) {
        NSDictionary *dic = [[HRRequestCacheManager sharedRequestCache] selectValidCacheForKey:manager.requestName cacheValidTime:manager.cacheValidTime];
        if (dic) {
            [generator requestDataPrintWithName:manager.requestName method:@"Cache" url:@"Local Cache" params:manager.params header:manager.headers response:dic error:nil];
            result(dic, nil);
            return nil;
        }
    }
    
    // 配置
    HRHttpRequestProxy *proxy = [HRHttpRequestProxy sharedProxy];
    proxy.header = manager.headers;
    proxy.useHTTPs = manager.useHTTPs;
    proxy.contentType = manager.contentType;
    proxy.requestSerializerWithHTTP = manager.requestSerializerWithHTTP;
    NSString *URL = [NSString stringWithFormat:@"%@%@", manager.baseUrl, manager.pathUrl];
    switch (manager.method) {
        case HRRequestMethodGet: {
            return [proxy callGETRequestWithURL:URL params:manager.params success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject)  {
                result(responseObject, nil);
                // 保存缓存
                [[HRRequestCacheManager sharedRequestCache] addCache:responseObject key:manager.requestName time:manager.cacheValidTime];
                // 格式化输出
                [generator requestDataPrintWithName:manager.requestName method:@"GET" url:URL params:manager.params header:manager.headers response:responseObject error:nil];
            } failure:^(NSURLSessionTask * _Nonnull task, id  _Nonnull error) {
                result(nil, error);
                [generator requestDataPrintWithName:manager.requestName method:@"GET" url:URL params:manager.params header:manager.headers response:nil error:error];
            }];
        }
            break;
        case HRRequestMethodPost: {
            if (manager.constructing) {
                // 上传
                return [proxy uploadFileWithURL:URL params:manager.params constructingBodyWithBlock:manager.constructing success:^(NSURLSessionTask *task, id responseObject) {
                    result(responseObject, nil);
                    [generator requestDataPrintWithName:manager.requestName method:@"POST" url:URL params:manager.params header:manager.headers response:responseObject error:nil];
                } failure:^(NSURLSessionTask *task, id error) {
                    result(nil, error);
                    [generator requestDataPrintWithName:manager.requestName method:@"POST" url:URL params:manager.params header:manager.headers response:nil error:error];
                }];
            } else {
                return [proxy callPOSTRequestWithURL:URL params:manager.params success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
                    result(responseObject, nil);
                    [[HRRequestCacheManager sharedRequestCache] addCache:responseObject key:manager.requestName time:manager.cacheValidTime];
                    [generator requestDataPrintWithName:manager.requestName method:@"POST" url:URL params:manager.params header:manager.headers response:responseObject error:nil];
                } failure:^(NSURLSessionTask * _Nonnull task, id  _Nonnull error) {
                    result(nil, error);
                    [generator requestDataPrintWithName:manager.requestName method:@"POST" url:URL params:manager.params header:manager.headers response:nil error:error];
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark print format
/**
 *  格式化输出请求
 *
 *  @param name     名称
 *  @param url      地址
 *  @param params   参数
 *  @param header   头
 *  @param response 返回值
 *  @param error    错误信息
 */
- (void)requestDataPrintWithName:(NSString *)name method:(NSString *)method url:(NSString *)url params:(NSDictionary *)params header:(NSDictionary *)header response:(NSDictionary *)response error:(NSError *)error {
    NSMutableString *urlStr = url.mutableCopy;
    if ([method isEqualToString:@"GET"]) {
        [urlStr stringByAppendingString:@"?"];
        __block int count = 0;
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            count += 1;
            [urlStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, obj]];
            if (count != params.allKeys.count) {
                [urlStr stringByAppendingString:@"&"];
            }
        }];
    }
    NSMutableString *printStr = [NSMutableString stringWithFormat:@"\n***【%@】【%@】***\n\n【URL】 %@\n\n【Params】\n", method, name, urlStr];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *temp = [NSString stringWithFormat:@"    %@: %@\n", key, obj];
        [printStr appendString:temp];
    }];
    [printStr appendString:@"\n【Header】\n"];
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *temp = [NSString stringWithFormat:@"    %@: %@\n", key, obj];
        [printStr appendString:temp];
    }];
    [printStr appendFormat:@"\n【Response】\n%@\n\n【Error】\n%@\n******", [response description], error];
    NSLog(@"\n%@", printStr);
}


@end
