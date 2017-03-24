//
//  TestPOSTMethodAPI.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/24.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "TestPOSTMethodAPI.h"

@implementation TestPOSTMethodAPI
{
    NSString *_articleId;
    NSString *_comment;
}

- (instancetype)initWithArticleId:(NSString *)articleId comment:(NSString *)comment {
    self = [super init];
    if (self) {
        _articleId = articleId ?: @"";
        _comment = comment ?: @"";
    }
    return self;
}

- (HRRequestMethod)method {
    return HRRequestMethodPost;
}

- (NSString *)pathUrl {
    return @"/platform-web/app/commentArticle";
}

- (NSDictionary *)params {
    return @{@"articleId":_articleId,
             @"comment":_comment};
}

@end
