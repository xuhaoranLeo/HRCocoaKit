//
//  UITextField+ValidChar.m

//
//  Created by 许昊然 on 16/7/19.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "UITextField+ValidChar.h"
#import <objc/runtime.h>

@implementation UITextField (ValidChar)

static char kHaveDianKey;

- (NSNumber *)isHaveDian {
    return objc_getAssociatedObject(self, &kHaveDianKey);
}

- (void)setIsHaveDian:(NSNumber *)isHaveDian {
    objc_setAssociatedObject(self, &kHaveDianKey, isHaveDian, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)validateNumberDot:(NSString *)string range:(NSRange)range count:(NSInteger)count {
    if ([self.text rangeOfString:@"."].location == NSNotFound) {
        self.isHaveDian = @(NO);
    }
    if ([string length]>0) {
        unichar single=[string characterAtIndex:0];
        if ((single >= '0' && single<= '9') || single=='.') {
            if(!self.text.length){
                if(single == '.') {
                    [self.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
//                if (single == '0') {
//                    [self.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
            }
            if (single == '.') {
                if(!self.isHaveDian.boolValue) {
                    self.isHaveDian=@(YES);
                    return YES;
                } else {
                    [self.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            } else {
                if (self.isHaveDian.boolValue) {
                    NSRange ran=[self.text rangeOfString:@"."];
                    NSInteger tt=range.location-ran.location;
                    if (tt <= count) {
                        return YES;
                    } else {
                        return NO;
                    }
                } else {
                    return YES;
                }
            }
        } else {
            [self.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else {
        return YES;  
    }
}

- (BOOL)validateNumber:(NSString*)string count:(NSInteger)count {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (self.text.length >= count) {
        return NO;
    }
    BOOL res = YES;
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSRange range = [string rangeOfCharacterFromSet:set];
    if (range.length == 0) {
        res = NO;
    }
    return res;
}

- (BOOL)validateIDCard:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (self.text.length >= 18) {
        return NO;
    }
    BOOL res = YES;
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX"];
    NSRange range = [string rangeOfCharacterFromSet:set];
    if (range.length == 0) {
        res = NO;
    }
    return res;
}

- (BOOL)filterSpecialCharacters:(NSString *)string count:(NSInteger)count {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (self.text.length >= count && count > 0) {
        return NO;
    }
    BOOL res = YES;
    // 除了@和_都不可输入
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" ！!#$￥%^…&*（()）-——=+／/？?、，,.。》《<>：；;:\"＂‘’“”'「」[]{}【】\\|~`·€•➍"];
    NSRange range = [string rangeOfCharacterFromSet:set];
    if (range.length > 0) {
        res = NO;
    }
    return res;
}

@end
