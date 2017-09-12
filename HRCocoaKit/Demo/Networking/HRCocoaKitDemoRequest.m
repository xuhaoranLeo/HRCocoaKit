//
//  HRCocoaKitDemoRequest.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/24.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HRCocoaKitDemoRequest.h"
#import "NetworkingConfiguration.h"

@implementation HRCocoaKitDemoRequest

- (NSString *)baseUrl {
    return kBaseAPI;
}

- (NSDictionary *)headers {
    NSDictionary *dic = @{@"CUSTOM_ID":@"9ac5e318-043e-46eb-92b0-4fe5041bfa90",
                          @"ACCESS_TOKEN":@"gbIgIUyamGQSuUNGj2nQYw==",
                          @"DEVICE_ID":@"device_id",
                          @"SOURCE_TYPE":@"iPhone",
                          @"VERSION":@"version"};
    NSString *headerStr = @"";
    for (NSString *key in dic.allKeys) {
        NSString *value = [dic objectForKey:key];
        headerStr = [headerStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, value]];
        if (![key isEqualToString:dic.allKeys.lastObject]) {
            headerStr = [headerStr stringByAppendingString:@";"];
        }
    }
    return @{@"this_is_a_header_string":headerStr};
}

- (BOOL)requestSerializerWithHTTP {
    return NO;
}

@end
