//
//  QrDemoViewController.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/4/18.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "QrDemoViewController.h"
#import "HRQrCodeViewController.h"

@interface QrDemoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation QrDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码扫描";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)scanAction:(id)sender {
    HRQrCodeViewController *qr = [[HRQrCodeViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    qr.completionBlock = ^(NSString *result, UIViewController *qcSelf) {
        weakSelf.resultLabel.text = result;
        [qcSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:qr animated:qr completion:nil];
}

@end
