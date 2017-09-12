//
//  HRHttpRequestProxy.h
//
//  Created by 许昊然 on 16/7/4.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^RequestFinished)(NSURLSessionTask * task, id responseObject);
typedef void(^RequestFailed)(NSURLSessionTask * task, id error);

@interface HRHttpRequestProxy : NSObject
+ (instancetype)sharedProxy;
@property (nonatomic, assign) BOOL useHTTPs;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSDictionary *header;
@property (nonatomic, assign) BOOL requestSerializerWithHTTP;
/**
 *  底层封装请求方法
 *
 *  @param URL     请求地址
 *  @param params  参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (NSURLSessionDataTask *)callGETRequestWithURL:(NSString *)URL params:(NSDictionary *)params success:(RequestFinished)success failure:(RequestFailed)failure;
- (NSURLSessionDataTask *)callPOSTRequestWithURL:(NSString *)URL params:(NSDictionary *)params success:(RequestFinished)success failure:(RequestFailed)failure;
/**
 *  上传数据方法
 *
 *  @param URL     请求地址
 *  @param params  参数
 *  @param block   上传数据的代码块
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (NSURLSessionDataTask *)uploadFileWithURL:(NSString *)URL params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(RequestFinished)success failure:(RequestFailed)failure;
@end
