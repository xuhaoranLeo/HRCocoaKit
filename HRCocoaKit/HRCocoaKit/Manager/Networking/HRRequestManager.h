//
//  HRRequestManager.h
//
//  Created by 许昊然 on 16/7/3.
//  Copyright © 2016年 许昊然. All rights reserved.
//
//  此类为所有网络请求的父类，每一个接口都继承于此并设置具体的请求配置。
//  缓存时间为0或者负数时不进行数据请求的本地存储，否则根据具体设置值进行缓存。

#import <Foundation/Foundation.h>
#import "HRHttpRequestGenerator.h"

typedef NS_ENUM(NSInteger , HRRequestMethod) {
    HRRequestMethodGet = 0,
    HRRequestMethodPost,
};

typedef void(^HandleData)(id handleData, BOOL success);
typedef void(^ErrorInfo)(NSError *error);

typedef void (^AFConstructingBlock)(id <AFMultipartFormData> formData);

@interface HRRequestManager : NSObject

#pragma mark - public configuration
/**
 *  返回数据data的字面量，默认为"data"
 */
@property (nonatomic, strong) NSString *dataStr;
/**
 *  返回数据code的字面量，默认为"code"
 */
@property (nonatomic, strong) NSString *codeStr;
/**
 *  返回数据msg的字面量，默认为"msg"
 */
@property (nonatomic, strong) NSString *msgStr;
/**
 *  返回数据code成功的字符串，默认为"1"
 */
@property (nonatomic, strong) NSString *successStr;
/**
 *  返回数据code失败的字符串，默认为"0"
 */
@property (nonatomic, strong) NSString *failureStr;

/**
 *  请求方法，默认GET请求
 */
@property (nonatomic, assign) HRRequestMethod method;
/**
 *  请求名称，用于输出信息，默认为子类接口的类名
 */
@property (nonatomic, strong) NSString *requestName;
/**
 *  主地址，设置默认值
 */
@property (nonatomic, strong) NSString *baseUrl;
/**
 *  子地址，无默认值
 */
@property (nonatomic, strong) NSString *pathUrl;
/**
 *  参数
 */
@property (nonatomic, strong) NSDictionary *params;
/**
 *  请求头，有默认值
 */
@property (nonatomic, strong) NSDictionary *headers;
/**
 *  content-type，默认为"application/json;charset=utf-8"
 */
@property (nonatomic, strong) NSString *contentType;
/**
 *  请求数据使用HTTP格式，默认为NO，使用JSON请求格式
 */
@property (nonatomic, assign) BOOL requestSerializerWithHTTP;
/**
 *  上传数据的结构
 */
@property (nonatomic, copy) AFConstructingBlock constructing;
/**
 *  使用HTTPs协议，默认为NO
 */
@property (nonatomic, assign) BOOL useHTTPs;
/**
 *  数据缓存时间，默认缓存时间0
 */
@property (nonatomic, assign) float cacheValidTime;
/**
 *  禁止缓存，默认不禁止，一般用在上拉加载
 */
@property (nonatomic, assign) BOOL banCache;
/**
 *  手动操作弹窗，自动的逻辑为请求接口弹出loading，接口调用成功loading消失，调用失败弹出失败原因
 */
@property (nonatomic, assign) BOOL manualHUDOperation;
/**
 *  请求成功后保存值
 */
@property (nonatomic, strong) NSDictionary *responseDic;

#pragma mark - request method
/**
 *  发起请求
 *
 *  @param handle    请求后的数据
 *  @param errorInfo 错误信息
 */
- (void)start:(HandleData)handle error:(ErrorInfo)errorInfo NS_REQUIRES_SUPER;

/**
 another request method
 */
@property (nonatomic, copy) HandleData handle;
@property (nonatomic, copy) ErrorInfo errorInfo;
- (void)start NS_REQUIRES_SUPER;

/**
 *  停止当前请求
 */
- (void)stop NS_REQUIRES_SUPER;
@end
