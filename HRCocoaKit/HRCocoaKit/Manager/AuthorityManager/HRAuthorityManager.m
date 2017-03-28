//
//  HRAuthorityManager.m
//  OpenURL
//
//  Created by xuhaoran on 16/5/31.
//  Copyright © 2016年 house365. All rights reserved.
//

#import "HRAuthorityManager.h"
#import <UIKit/UIKit.h>
#import "UIViewController+CurrentViewController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>
#import <EventKit/EventKit.h>
#import <ContactsUI/ContactsUI.h>

@interface HRAuthorityManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *locationTip;
@property (nonatomic, copy) HRLocationStatusChanged locationSettingChanged;
@property (nonatomic, copy) HRCurrentCityInfo currentCityInfo;
@end

@implementation HRAuthorityManager

+ (instancetype)sharedManager {
    __strong static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init];
            
        }
    });
    return sharedManager;
}
#pragma mark - 相册
- (void)getAlbumAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (!result) {
            return;
        }
        HRAuthorityStatus authorityStatus;
        switch (status) {
            case PHAuthorizationStatusNotDetermined:
                authorityStatus = HRAuthorityStatusNotDetermined;
                break;
            case PHAuthorizationStatusRestricted:
                authorityStatus = HRAuthorityStatusRestricted;
                break;
            case PHAuthorizationStatusDenied:
                authorityStatus = HRAuthorityStatusDenied;
                break;
            case PHAuthorizationStatusAuthorized:
                authorityStatus = HRAuthorityStatusAuthorized;
                break;
        }
        if ((authorityStatus == HRAuthorityStatusRestricted || authorityStatus == HRAuthorityStatusDenied) && tip.length) {
            [self showMsg:tip];
        } else {
            result(authorityStatus);
        }
    }];
}
#pragma mark - 摄像头
- (void)getCameraAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!result) {
            return;
        }
        HRAuthorityStatus authorityStatus;
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined:
                authorityStatus = HRAuthorityStatusNotDetermined;
                break;
            case AVAuthorizationStatusRestricted:
                authorityStatus = HRAuthorityStatusRestricted;
                break;
            case AVAuthorizationStatusDenied:
                authorityStatus = HRAuthorityStatusDenied;
                break;
            case AVAuthorizationStatusAuthorized:
                authorityStatus = HRAuthorityStatusAuthorized;
                break;
        }
        if ((authorityStatus == HRAuthorityStatusRestricted || authorityStatus == HRAuthorityStatusDenied) && tip.length) {
            [self showMsg:tip];
        } else {
            result(authorityStatus);
        }
        
    }];
}
#pragma mark - 麦克风
- (void)getAudioAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (!result) {
            return;
        }
        HRAuthorityStatus authorityStatus;
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        switch (status) {
            case AVAuthorizationStatusNotDetermined:
                authorityStatus = HRAuthorityStatusNotDetermined;
                break;
            case AVAuthorizationStatusRestricted:
                authorityStatus = HRAuthorityStatusRestricted;
                break;
            case AVAuthorizationStatusDenied:
                authorityStatus = HRAuthorityStatusDenied;
                break;
            case AVAuthorizationStatusAuthorized:
                authorityStatus = HRAuthorityStatusAuthorized;
                break;
        }
        if ((authorityStatus == HRAuthorityStatusRestricted || authorityStatus == HRAuthorityStatusDenied) && tip.length) {
            [self showMsg:tip];
        } else {
            result(authorityStatus);
        }
    }];
}
#pragma mark - 电话簿
- (void)getAddressBookAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip {
    if (!result) {
        return;
    }
    __weak typeof(self) weakSelf = self;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            HRAuthorityStatus authorityStatus;
            if (error) {
                [weakSelf showMsg:@"获取通讯录失败"];
                return;
            }
            if (granted == NO) {
                authorityStatus = HRAuthorityStatusDenied;
            } else {
                authorityStatus = HRAuthorityStatusAuthorized;
            }
            if ((authorityStatus == HRAuthorityStatusRestricted || authorityStatus == HRAuthorityStatusDenied) && tip.length) {
                [weakSelf showMsg:tip];
            } else {
                result(authorityStatus);
            }
        }];
    }
#else
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        HRAuthorityStatus authorityStatus;
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusNotDetermined:
                authorityStatus = HRAuthorityStatusNotDetermined;
                break;
            case kABAuthorizationStatusRestricted:
                authorityStatus = HRAuthorityStatusRestricted;
                break;
            case kABAuthorizationStatusDenied:
                authorityStatus = HRAuthorityStatusDenied;
                break;
            case kABAuthorizationStatusAuthorized:
                authorityStatus = HRAuthorityStatusAuthorized;
                break;
        }
        if ((authorityStatus == HRAuthorityStatusRestricted || authorityStatus == HRAuthorityStatusDenied) && tip.length) {
            [weakSelf showMsg:tip];
        } else {
            result(authorityStatus);
        }
    });
    CFRelease(addressBook);
#endif
}

#pragma mark - 日历
- (void)getEventAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (!result) {
            return;
        }
        HRAuthorityStatus authorityStatus;
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        switch (status) {
            case EKAuthorizationStatusNotDetermined:
                authorityStatus = HRAuthorityStatusNotDetermined;
                break;
            case EKAuthorizationStatusRestricted:
                authorityStatus = HRAuthorityStatusRestricted;
                break;
            case EKAuthorizationStatusDenied:
                authorityStatus = HRAuthorityStatusDenied;
                break;
            case EKAuthorizationStatusAuthorized:
                authorityStatus = HRAuthorityStatusAuthorized;
                break;
        }
        if ((authorityStatus == HRAuthorityStatusRestricted || authorityStatus == HRAuthorityStatusDenied) && tip.length) {
            [self showMsg:tip];
        } else {
            result(authorityStatus);
        }
    }];
}
#pragma mark - 备忘录
- (void)getReminderAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        if (!result) {
            return;
        }
        HRAuthorityStatus authorityStatus;
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
        switch (status) {
            case EKAuthorizationStatusNotDetermined:
                authorityStatus = HRAuthorityStatusNotDetermined;
                break;
            case EKAuthorizationStatusRestricted:
                authorityStatus = HRAuthorityStatusRestricted;
                break;
            case EKAuthorizationStatusDenied:
                authorityStatus = HRAuthorityStatusDenied;
                break;
            case EKAuthorizationStatusAuthorized:
                authorityStatus = HRAuthorityStatusAuthorized;
                break;
        }
        if ((authorityStatus == HRAuthorityStatusRestricted || authorityStatus == HRAuthorityStatusDenied) && tip.length) {
            [self showMsg:tip];
        } else {
            result(authorityStatus);
        }
    }];
}

#pragma mark - 推送通知
- (void)getNotificationAuthority {
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}
#pragma mark - 定位
- (void)getLocationAuthority:(HRLocationStatusChanged)locationSettingChanged failureTip:(NSString *)tip {
    self.locationSettingChanged = locationSettingChanged;
    self.locationTip = tip;
    [self.locationManager requestWhenInUseAuthorization];
}

- (BOOL)canLocatePosition {
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (!(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        return NO;
    }
    return YES;
}

#pragma mark - 当前城市
- (void)getCurrentCityInfo:(HRCurrentCityInfo)info {
    [self.locationManager startUpdatingLocation];
    self.currentCityInfo = info;
}

#pragma mark 定位代理
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (self.locationSettingChanged) {
        if (![self canLocatePosition] && self.locationTip.length) {
            [self showMsg:self.locationTip];
        }
        self.locationSettingChanged(manager, [self canLocatePosition]);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    __weak typeof(self) weakSelf = self;
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count) {
            CLPlacemark *placemark = placemarks.firstObject;
            NSMutableArray *temp = [NSMutableArray array];
            [temp addObject:placemark.administrativeArea];
            [temp addObject:placemark.locality];
            [temp addObject:placemark.subLocality];
            [temp addObject:placemark.thoroughfare];
            weakSelf.currentCityInfo(temp.copy, location.coordinate);
        } else {
            weakSelf.currentCityInfo(@[], location.coordinate);
        }
        
    }];
    [manager stopUpdatingLocation];
}

#pragma mark 初始化manager
- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

#pragma mark - alert
- (void)showMsg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                dispatch_after(0.2, dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] openURL:url];
                });
            }
        }];
        [alert addAction:action];
        [[UIViewController getCurrentVC] presentViewController:alert animated:YES completion:nil];
    });
}

@end
