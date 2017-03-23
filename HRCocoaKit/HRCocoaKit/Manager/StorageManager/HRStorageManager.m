//
//  StorageManager.m

//
//  Created by 许昊然 on 16/7/21.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRStorageManager.h"

static NSString * const FileName = @"LocalStorage";

@interface HRStorageManager ()
@property (nonatomic, strong) NSString *storagePath;
@end

@implementation HRStorageManager

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (BOOL)writeWithData:(id)data storageType:(NSString *)type {
    HRStorageManager *mamager = [HRStorageManager sharedManager];
    NSString *path = [mamager.storagePath stringByAppendingPathComponent:type];
    NSData *temp = [NSKeyedArchiver archivedDataWithRootObject:data];
    return [NSKeyedArchiver archiveRootObject:temp toFile:path];
}

+ (id)readWithStorageType:(NSString *)type {
    HRStorageManager *mamager = [HRStorageManager sharedManager];
    NSString *path = [mamager.storagePath stringByAppendingPathComponent:type];
    NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (!data) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (BOOL)removeDataWithStorageType:(NSString *)type {
    HRStorageManager *mamager = [HRStorageManager sharedManager];
    NSString *path = [mamager.storagePath stringByAppendingPathComponent:type];
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (void)removeAllCacheExceptStorageType:(NSArray <NSString *> *)typeArr finish:(void(^)())finish {
    HRStorageManager *mamager = [HRStorageManager sharedManager];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:mamager.storagePath];
        NSString *fileName;
        while (fileName= [dirEnum nextObject]) {
            if ([typeArr containsObject:fileName] && typeArr) {
                break;
            }
            NSString *path = [mamager.storagePath stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finish) {
                finish();
            }
        });
    });
}

+ (void)removeAllCache:(void(^)())finish {
    [HRStorageManager removeAllCacheExceptStorageType:nil finish:finish];
}

+ (NSInteger)calculateCacheSize {
    HRStorageManager *mamager = [HRStorageManager sharedManager];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:mamager.storagePath]) {
        return 0;
    }
    NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:mamager.storagePath];
    NSString *fileName;
    long long total = 0;
    while (fileName= [dirEnum nextObject]) {
        NSString *path = [mamager.storagePath stringByAppendingPathComponent:fileName];
        total += [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize]
        ;
    }
    return @(total).integerValue;
}

#pragma mark - getter
- (NSString *)storagePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:FileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return path;
}

@end
