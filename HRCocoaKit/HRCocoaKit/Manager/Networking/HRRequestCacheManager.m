//
//  HRRequestCacheManager.m
//
//  Created by 许昊然 on 16/7/6.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRRequestCacheManager.h"
#import "NSDate+TimeStamp.h"

static NSString * const FileName     = @"RequestCache";
static NSString * const TimeStampKey = @"timestamp";
static NSString * const DataKey      = @"data";

@interface HRRequestCacheManager ()
@end
@implementation HRRequestCacheManager

#pragma mark - public method
+ (instancetype)sharedRequestCache {
    static id sharedRequestCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRequestCache = [[self alloc] init];
    });
    return sharedRequestCache;
}

- (BOOL)addCache:(NSDictionary *)data key:(NSString *)key time:(float)time {
    if (time <= 0) {
        return NO;
    }
    NSString *path = [self.cachePath stringByAppendingPathComponent:key];
    NSString *timestamp = [NSDate getCurrentTimeStamp];
    NSDictionary *dic = @{TimeStampKey:timestamp, DataKey:data};
    NSData *temp = [NSKeyedArchiver archivedDataWithRootObject:dic];
    return [NSKeyedArchiver archiveRootObject:temp toFile:path];
}

- (NSDictionary *)selectValidCacheForKey:(NSString *)key cacheValidTime:(float)time {
    if (time <= 0) {
        return nil;
    }
    NSString *path = [self.cachePath stringByAppendingPathComponent:key];
    NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (!data) {
        return nil;
    }
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSInteger timestamp = (long)[dic[TimeStampKey] integerValue];
    NSInteger current = (long)[[NSDate getCurrentTimeStamp] integerValue];
    if (current - timestamp > time) {
        [self removeCacheForKey:key];
        return nil;
    }
    return dic[DataKey];
}

- (NSDictionary *)selectValidCacheForKey:(NSString *)key {
    NSString *path = [self.cachePath stringByAppendingPathComponent:key];
    NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (!data) {
        return nil;
    }
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dic[DataKey];
}

- (BOOL)removeCacheForKey:(NSString *)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [self.cachePath stringByAppendingPathComponent:key];
    return  [fileManager removeItemAtPath:path error:nil];
}

- (void)removeAllCache {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:self.cachePath];
        NSString *fileName;
        while (fileName= [dirEnum nextObject]) {
            NSString *path = [self.cachePath stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    });
}

- (long long)calculateCacheSize {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:self.cachePath]) {
        return 0;
    }
    NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:self.cachePath];
    NSString *fileName;
    long long total = 0;
    while (fileName= [dirEnum nextObject]) {
        NSString *path = [self.cachePath stringByAppendingPathComponent:fileName];
        total += [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize]
        ;
    }
    return total;
}

#pragma mark - getter
- (NSString *)cachePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:FileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return path;
}

@end
