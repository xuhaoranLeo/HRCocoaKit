//
//  StorageViewController.m
//  HRCocoaKit
//
//  Created by 许昊然 on 2017/3/22.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "StorageViewController.h"
#import "HRStorageProperty.h"
#import "HRStorageManager.h"

@interface StorageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;
@property (weak, nonatomic) IBOutlet UITextField *storeKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *storeDataTextField;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;
@property (weak, nonatomic) IBOutlet UIButton *readButton;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearCacheButton;

@end

@implementation StorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"本地存储";
    self.view.backgroundColor = [UIColor whiteColor];
    self.cacheSizeLabel.text = [NSString stringWithFormat:@"缓存：%.2fB", [self getCacheSize]];
}

#pragma mark - response action
- (IBAction)writeAction:(id)sender {
    NSString *key = self.storeKeyTextField.text ?: kUserInfoStore;
    if (self.storeDataTextField.text.length == 0) {
        return;
    }
    [HRStorageManager writeWithData:self.storeDataTextField.text storageType:key];
    self.cacheSizeLabel.text = [NSString stringWithFormat:@"缓存：%.2fB", [self getCacheSize]];
    self.dataLabel.text = @"数据：";
}

- (IBAction)readAction:(id)sender {
    NSString *key = self.storeKeyTextField.text ?: kUserInfoStore;
    id data = [HRStorageManager readWithStorageType:key];
    self.dataLabel.text = [NSString stringWithFormat:@"数据：%@", data];
    self.storeDataTextField.text = @"";
}

- (IBAction)clearAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [HRStorageManager removeAllCache:^{
        weakSelf.cacheSizeLabel.text = [NSString stringWithFormat:@"缓存：%.2fB", [self getCacheSize]];
    }];
}

#pragma mark - private method
- (CGFloat)getCacheSize {
    long long storgeCache = [HRStorageManager calculateCacheSize:nil];
    // return Byte
    return storgeCache;
}
@end
