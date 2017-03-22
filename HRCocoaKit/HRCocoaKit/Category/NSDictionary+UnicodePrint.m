//
//  NSDictionary+UnicodePrint.m
//
//  Created by 许昊然 on 16/7/7.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "NSDictionary+UnicodePrint.h"
#import <objc/runtime.h>

@implementation NSDictionary (UnicodePrint)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(description)), class_getInstanceMethod([self class], @selector(my_description)));
}

- (NSString*)my_description {
    NSString *desc = [self my_description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    desc = [desc stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (desc == nil) {
//        // 部分情况解码失败用此方法
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonString;
        return nil;
    }
    return desc;
}

@end
