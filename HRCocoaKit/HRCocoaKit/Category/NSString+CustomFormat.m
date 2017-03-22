//
//  NSString+CustomFormat.m

//
//  Created by 许昊然 on 16/7/18.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "NSString+CustomFormat.h"

@implementation NSString (CustomFormat)

- (NSMutableAttributedString *)changeStringColor:(NSString *)needChangeString color:(UIColor *)color {
    return [self changeStringColor:needChangeString color:color font:nil];
}

- (NSMutableAttributedString *)changeStringFont:(NSString *)needChangeString font:(UIFont *)font {
    return [self changeStringColor:needChangeString color:nil font:font];    
}

- (NSMutableAttributedString *)changeStringColor:(NSString *)needChangeString color:(UIColor *)color font:(UIFont *)font {
    return [self changeStringFormat:needChangeString color:color font:font underLine:NO midLine:NO originalAttribute:nil];
}

- (NSMutableAttributedString *)addUnderLine:(NSString *)needChangeString {
    return [self changeStringFormat:needChangeString color:nil font:nil underLine:YES midLine:NO originalAttribute:nil];
}

- (NSMutableAttributedString *)addMidLine:(NSString *)needChangeString {
    return [self changeStringFormat:needChangeString color:nil font:nil underLine:NO midLine:YES originalAttribute:nil];
}

- (NSMutableAttributedString *)changeStringFormat:(NSString *)needChangeString color:(UIColor *)color font:(UIFont *)font underLine:(BOOL)under midLine:(BOOL)mid originalAttribute:(NSMutableAttributedString *)origin {
    NSRange range = [self rangeOfString:needChangeString];
    NSMutableDictionary *format = [[NSMutableDictionary alloc] init];
    if (color) {
        [format setObject:color forKey:NSForegroundColorAttributeName];
    }
    if (font) {
        [format setObject:font forKey:NSFontAttributeName];
    }
    if (under) {
        [format setObject:[NSNumber numberWithInteger:NSUnderlineStyleSingle] forKey:NSUnderlineStyleAttributeName];
    }
    if (mid) {
        [format setObject:[NSNumber numberWithInteger:NSUnderlineStyleSingle] forKey:NSStrikethroughStyleAttributeName];
    }
    if (origin) {
        [origin addAttributes:format range:range];
        return origin;
    }
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self];
    [attribute addAttributes:format range:range];
    return attribute;
}

@end
