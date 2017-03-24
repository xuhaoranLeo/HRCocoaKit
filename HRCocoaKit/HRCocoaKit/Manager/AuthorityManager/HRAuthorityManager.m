//
//  HRAuthorityManager.m
//  OpenURL
//
//  Created by xuhaoran on 16/5/31.
//  Copyright © 2016年 house365. All rights reserved.
//

#import "HRAuthorityManager.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>
#import <EventKit/EventKit.h>
#import "UIViewController+CurrentViewController.h"
#import <ContactsUI/ContactsUI.h>

#ifdef HRAuthorityUseHealthKit
#import <HealthKit/HealthKit.h>
#endif

@interface HRAuthorityManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *locationTip;
@property (nonatomic, copy) HRLocationStatusChanged locationSettingChanged;
@property (nonatomic, copy) HRCurrentCityInfo currentCityInfo;
#ifdef HRAuthorityUseHealthKit
@property (nonatomic, strong) HKHealthStore *healthStore;
#endif
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

#ifdef HRAuthorityUseHealthKit
#pragma mark - 健康数据
- (void)getHealthDataAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip {
    if (![HKHealthStore isHealthDataAvailable]) {
        [self showMsg:@"该设备不支持健康功能"];
        return;
    }
    self.healthStore = [[HKHealthStore alloc] init];
    // update 权限
    /*
     HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight]; // 身高
     HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]; // 体重
     HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature]; // 提问
     HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned]; // 脂肪消耗
     NSSet *writeDataTypes = [NSSet setWithObjects:heightType, temperatureType, weightType,activeEnergyType,nil];
     */
    // read 权限
    /*
     HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight]; // 身高
     HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]; // 体重
     HKQuantityType *temperatureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature]; // 提问
     HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth]; // 生日
     HKCharacteristicType *sexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex]; // 性别
     HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned]; // 能耗
     */
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]; // 步数
    HKQuantityType *distance = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning]; // 距离
    NSSet *readDataTypes = [NSSet setWithObjects:stepCountType, distance,nil];
    __weak typeof(self) weakSelf = self;
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
        if (result == nil) {
            return;
        }
        if (success) {
            result(HRAuthorityStatusAuthorized);
        } else {
            [weakSelf showMsg:tip];
        }
    }];
}

#pragma mark 获取今日步数
- (void)getStepCountInToday:(void (^)(double, NSError *))result {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:[HRAuthorityManager predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (result == nil) {
            return;
        }
        if (error) {
            result(0, error);
        } else {
            NSInteger totleSteps = 0;
            for(HKQuantitySample *quantitySample in results) {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *heightUnit = [HKUnit countUnit];
                double usersHeight = [quantity doubleValueForUnit:heightUnit];
                totleSteps += usersHeight;
            }
            result(totleSteps, error);
        }
    }];
    [self.healthStore executeQuery:query];
}
#pragma mark 获取今日公里数
- (void)getDistanceInToday:(void (^)(double, NSError *))result {
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:distanceType predicate:[HRAuthorityManager predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if(error) {
            result(0,error);
        } else {
            double distance = 0;
            for(HKQuantitySample *quantitySample in results)
            {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *distanceUnit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
                double kilo = [quantity doubleValueForUnit:distanceUnit];
                distance += kilo;
            }
            result(distance, error);
        }
    }];
    [self.healthStore executeQuery:query];
}
// 获取今日的断言
+ (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}
#endif

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
