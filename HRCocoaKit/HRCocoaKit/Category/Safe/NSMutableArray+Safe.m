//
//  NSMutableArray+Safe.m

//
//  Created by 许昊然 on 16/7/11.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
        [obj swizzleMethod:@selector(addObject:) withMethod:@selector(hr_SafeAddObject:)];
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(hr_SafeObjectAtIndex:)];
    });
}

- (void)swizzleMethod:(SEL)originalSEL withMethod:(SEL)swizzledSEL {
    Method originalMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), originalSEL);
    Method swizzledMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), swizzledSEL);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)hr_SafeAddObject:(id)anObject {
    if (anObject) {
        [self hr_SafeAddObject:anObject];
    } else {
        @try {
            [self hr_SafeAddObject:anObject];
        }
        @catch (NSException *exception) {
            NSLog(@"\n\n---------- %s Crash Because Method %s  ----------\n\n", class_getName(self.class), __func__);
        }
        @finally {}
    }
}

- (id)hr_SafeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self hr_SafeObjectAtIndex:index];
    } else {
        @try {
            return [self hr_SafeObjectAtIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"\n\n---------- %s Crash Because Method %s  ----------\n\n", class_getName(self.class), __func__);
            return nil;
        }
        @finally {}
    }
}


@end
