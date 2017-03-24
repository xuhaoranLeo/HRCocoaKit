//
//  NetworkingViewController.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/24.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "NetworkingViewController.h"
#import "TestGETMethodAPI.h"
#import "TestPOSTMethodAPI.h"
#import "TestUploadAPI.h"
#import "HRCocoaKit.h"

@interface NetworkingViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation NetworkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网络请求";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 相机
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    TestUploadAPI *api = [[TestUploadAPI alloc] initWithImage:image];
    api.banLoadingHUD = YES;
    [HRHUDManager showPermanentAlert:@"上传中..."];
    [api start:^(id handleData, BOOL success) {
        [HRHUDManager dismissAlert];
    } error:^(NSError *error) {
    }];
}

#pragma mark - response action
- (IBAction)GETAction:(id)sender {
    TestGETMethodAPI *api = [[TestGETMethodAPI alloc] initWithParam1:@"第一个参数" param2:@"第二个参数"];
    [api start:^(id handleData, BOOL success) {
    } error:^(NSError *error) {
    }];
}

- (IBAction)POSTAction:(id)sender {
    TestPOSTMethodAPI *api = [[TestPOSTMethodAPI alloc] initWithArticleId:@"123" comment:@"哈哈哈"];
    [api start:^(id handleData, BOOL success) {
    } error:^(NSError *error) {
    }];
}

- (IBAction)cameraAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[HRAuthorityManager sharedManager] getCameraAuthority:^(HRAuthorityStatus status) {
        if (status == HRAuthorityStatusAuthorized) {
            // 相机
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.allowsEditing = YES;    // 允许编辑
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = weakSelf;
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        }
    } failureTip:@"您已经禁止调用相机了，请点击去开启"];
}
@end
