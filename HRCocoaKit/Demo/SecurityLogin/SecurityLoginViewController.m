//
//  SecurityLoginViewController.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/24.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "SecurityLoginViewController.h"
#import "HRCocoaKit.h"

static NSString *kKeychainService = @"com.xuhaoran.keychaindemo";
static NSString *kKeychainDeviceId    = @"KeychainDeviceId";

@interface SecurityLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@end

@implementation SecurityLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.uuidLabel.text = [NSString stringWithFormat:@"设备号:%@", [HRSecurityManager getDeviceId]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.accountTextField) {
        self.accountTextField.text = nil;
        self.passwordTextField.text = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.accountTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self loginAction:nil];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.accountTextField) {
        // 提取本地密码
        NSString *localPassword = [HRSecurityManager getPasswordWithUserName:textField.text];
        if (localPassword) {
            self.passwordTextField.text = localPassword;
        }
    }
}

#pragma mark - responce action
- (IBAction)loginAction:(id)sender {
    if (!self.accountTextField.text || !self.passwordTextField.text) {
        [HRHUDManager showBriefAlert:@"输入账号和密码!"];
        return;
    }
    [HRHUDManager showBriefAlert:[NSString stringWithFormat:@"账户名:%@\n密码:%@", self.accountTextField.text, self.passwordTextField.text]];
    // 保存账号密码
    [HRSecurityManager storePasswordWithUserName:self.accountTextField.text password:self.passwordTextField.text];
}

- (IBAction)clearAction:(id)sender {
    if (!self.accountTextField.text) {
        return;
    }
    if ([HRSecurityManager deletePasswordWithUserName:self.accountTextField.text]) {
        [HRHUDManager showBriefAlert:[NSString stringWithFormat:@"账户%@的密码已清空!", self.accountTextField.text]];
        self.accountTextField.text = @"";
        self.passwordTextField.text = @"";
    } else {
        [HRHUDManager showBriefAlert:@"删除失败了"];
    }
}

@end
