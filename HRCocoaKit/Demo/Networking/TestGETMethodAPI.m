//
//  TestGETMethodAPI.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/24.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "TestGETMethodAPI.h"

@implementation TestGETMethodAPI
{
    NSString *_param1;
    NSString *_param2;
}

- (instancetype)initWithParam1:(NSString *)param1 param2:(NSString *)param2 {
    self = [super init];
    if (self) {
        _param1 = param1 ?: @"";
        _param2 = param2 ?: @"";
    }
    return self;
}

- (NSString *)pathUrl {
    return @"/platform-web/app/recommend";
}

- (NSDictionary *)params {
    return @{@"param1":_param1,
             @"param1":_param2};
}

@end
