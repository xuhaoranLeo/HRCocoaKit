//
//  NSString+Empty.m

//
//  Created by 许昊然 on 16/7/11.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "NSString+Empty.h"

@implementation NSString (Empty)
+ (BOOL)isEmpty:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ((NSNull*)string == [NSNull null]) {
        return YES;
    }
    if (string.length == 0) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}
@end
