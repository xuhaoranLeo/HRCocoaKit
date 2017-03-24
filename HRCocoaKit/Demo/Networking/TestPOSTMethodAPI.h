//
//  TestPOSTMethodAPI.h
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/24.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HRCocoaKitDemoRequest.h"

@interface TestPOSTMethodAPI : HRCocoaKitDemoRequest
- (instancetype)initWithArticleId:(NSString *)articleId comment:(NSString *)comment;
@end
