//
//  HRQrCodeViewController.h
//  HRQrCode
//
//  Created by 许昊然 on 2017/3/2.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRQrCodeViewController : UIViewController

/**
 扫描结果
 */
@property (copy, nonatomic) void (^completionBlock)(NSString *result, UIViewController *qcSelf);
@end
