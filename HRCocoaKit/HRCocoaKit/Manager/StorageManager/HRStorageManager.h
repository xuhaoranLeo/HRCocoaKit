//
//  StorageManager.h

//
//  Created by 许昊然 on 16/7/21.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRStorageManager : NSObject

/**
 存储数据

 @param data 数据
 @param type 数据类型

 @return 成功失败
 */
+ (BOOL)writeWithData:(id)data storageType:(NSString *)type;

/**
 读取数据

 @param type 数据类型

 @return 读取的数据
 */
+ (id)readWithStorageType:(NSString *)type;

/**
 移除数据

 @param type 数据类型

 @return 成功失败
 */
+ (BOOL)removeDataWithStorageType:(NSString *)type;

/**
 移除指定类型以外的数据

 @param typeArr 保留数据的类型
 */
+ (void)removeAllCacheExceptStorageType:(NSArray <NSString *> *)typeArr;

/**
 移除所有数据
 */
+ (void)removeAllCache;

/**
 计算缓存大小

 @return 大小（字节）
 */
+ (NSInteger)calculateCacheSize;
@end
