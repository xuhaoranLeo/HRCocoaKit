//
//  HRQrCodeViewController.m
//  HRQrCode
//
//  Created by 许昊然 on 2017/3/2.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HRQrCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface HRQrCodeViewController () <AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineTop;
@property (weak, nonatomic) IBOutlet UIImageView *scanLine;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVAudioPlayer *beepPlayer;
@end

@implementation HRQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startScan];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAnimation];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count == 0 || metadataObjects == nil) {
        return;
    }
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects lastObject];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode] && [metadataObj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            self.resultLabel.text = @"扫描成功";
            NSString *result = [metadataObjects.lastObject stringValue];
            [self stopScan];
            if (self.completionBlock) {
                [self.beepPlayer play];
                __weak typeof(self) weakSelf = self;
                self.completionBlock(result, weakSelf);
            }
            return;
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(image)]];
        if (features.count >= 1) {
            CIQRCodeFeature *feature = features.firstObject;
            NSString *result = feature.messageString;
            weakSelf.resultLabel.text = @"扫描成功";
            [weakSelf stopScan];
            if (weakSelf.completionBlock) {
                [weakSelf.beepPlayer play];
                weakSelf.completionBlock(result, weakSelf);
            }
        }else{
            weakSelf.resultLabel.text = @"这并不是一个二维码";
        }
    }];
}

#pragma mark - response action
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)flashAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.isSelected) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOn];
            [device unlockForConfiguration];
        }
    } else {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}

- (IBAction)albumAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIImagePickerController *imagrPicker = [[UIImagePickerController alloc]init];
    imagrPicker.delegate = weakSelf;
    imagrPicker.allowsEditing = YES;
    imagrPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [weakSelf presentViewController:imagrPicker animated:YES completion:nil];
}

#pragma mark - private method
- (void)startScan {
    if (![self.session canAddInput:self.deviceInput]) {
        return;
    }
    if (![self.session canAddOutput:self.output]) {
        return;
    }
    [self.session addInput:self.deviceInput];
    [self.session addOutput:self.output];
    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    CGFloat ScreenHigh = [UIScreen mainScreen].bounds.size.height;
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    [self.output setRectOfInterest : CGRectMake (( 160.f )/ ScreenHigh ,(( ScreenWidth - 300 )/ 2.f )/ ScreenWidth , 300.f / ScreenHigh , 300.f / ScreenWidth)];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.session startRunning];
}

- (void)stopScan {
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    [self stopAnimation];
}

- (void)startAnimation {
    self.scanLineTop.constant = 0;
    [self.view layoutIfNeeded];
    self.scanLineTop.constant = 300;
    [UIView animateWithDuration:2 animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        [self.view layoutIfNeeded];
    }];
}

- (void)stopAnimation {
    [self.view.layer removeAllAnimations];
}

#pragma mark - getter
- (AVCaptureSession *)session {
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureDeviceInput *)deviceInput {
    if (_deviceInput == nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    }
    return _deviceInput;
}

- (AVCaptureMetadataOutput *)output {
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc] init];
    }
    return _output;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.frame = [UIScreen mainScreen].bounds;
    }
    return _previewLayer;
}

- (AVAudioPlayer *)beepPlayer {
    if (_beepPlayer == nil) {
        NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
        NSData* data = [[NSData alloc] initWithContentsOfFile:wavPath];
        _beepPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    }
    return _beepPlayer;
}

@end
