//
//  HRRequestCacheManager.h
//
//  Created by 许昊然 on 16/7/6.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CacheSizeBlcok)(NSInteger size, BOOL success);
@interface HRRequestCacheManager : NSObject
@property (nonatomic, strong, readonly) NSString *cachePath;
+ (instancetype)sharedRequestCache;
/**
 *  添加缓存
 *
 *  @param data 缓存数据
 *  @param key  缓存名称
 *  @param time 缓存时间
 *
 *  @return 成功与否
 */
- (BOOL)addCache:(NSDictionary *)data key:(NSString *)key time:(float)time;
/**
 *  提取具体缓存数据
 *
 *  @param key  缓存名称
 *  @param time 缓存有效期
 *
 *  @return 缓存数据
 */
- (NSDictionary *)selectValidCacheForKey:(NSString *)key cacheValidTime:(float)time;
- (NSDictionary *)selectValidCacheForKey:(NSString *)key;
/**
 *  删除具体缓存
 *
 *  @param key 缓存名称
 *
 *  @return 成功与否
 */
- (BOOL)removeCacheForKey:(NSString *)key;
- (void)removeAllCache;
/**
 *  计算缓存数据大小
 *
 *  @return 缓存大小
 */
- (NSInteger)calculateCacheSize;
@end
