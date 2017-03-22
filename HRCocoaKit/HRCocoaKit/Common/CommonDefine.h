//
//  CommonDefine.h
//
//  Created by 许昊然 on 16/7/11.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 输出宏
 */
#ifdef DEBUG
#define NSLog(format, ...) do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#else
#define NSLog(format, ...)
#endif

/*
 图片字符串拼接后转成URL
 */
#define kImageUrl(imageUrlStr) (![NSString isEmpty:imageUrlStr] ? ([NSURL URLWithString:imageUrlStr]) : nil)

#define kMultilineTextSize(text, font, maxSize) [text length] > 0 ? [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero

/*
 屏幕宽高宏
 */
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenBounds ([UIScreen mainScreen].bounds)

/*
 设备判断及字体设置
 */
#define iPhone3_5Inch ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4_0Inch ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4_7Inch ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone5_5Inch ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define kStandardFont(fontsize) ((iPhone5_5Inch) ? (fontsize+1) : ((iPhone4_7Inch) ? (fontsize) : (fontsize-1.5)))

/*
 颜色宏
 */
#define kRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kRGB(r,g,b) kRGBA(r,g,b,1.0f)
// format 0xFFFFFF
#define kHexRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define kLightGrayColor \
[UIColor colorWithRed:((float)((0xf0eff5 & 0xFF0000) >> 16)) / 255.0 \
green:((float)((0xf0eff5 & 0xFF00) >> 8)) / 255.0 \
blue:((float)(0xf0eff5 & 0xFF)) / 255.0 alpha:1.0]
/*
 版本宏
 */
#define kSystemVersion ([UIDevice currentDevice].systemVersion.floatValue)

/*
 四舍五入宏
 */
#define kRoundAfterPoint(number, position) ([[NSString stringWithFormat:@"%@",[[[NSDecimalNumber alloc] initWithFloat:number] decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO]]] floatValue])

