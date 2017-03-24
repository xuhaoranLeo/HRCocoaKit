//
//  HRAuthorityManager.h
//  OpenURL
//
//  Created by xuhaoran on 16/5/31.
//  Copyright © 2016年 house365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, HRAuthorityStatus) {
    HRAuthorityStatusAuthorized,
    HRAuthorityStatusNotDetermined,
    HRAuthorityStatusRestricted,
    HRAuthorityStatusDenied,
};

typedef void(^HRAuthorityResult)(HRAuthorityStatus status);
typedef void(^HRLocationStatusChanged)(CLLocationManager *manager, BOOL success);
typedef void(^HRCurrentCityInfo)(NSArray *locationArray, CLLocationCoordinate2D coordinate);

NS_CLASS_AVAILABLE_IOS(8_0) @interface HRAuthorityManager : NSObject

+ (instancetype)sharedManager;
// 相册
- (void)getAlbumAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip;
// 摄像头
- (void)getCameraAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip;
// 麦克风
- (void)getAudioAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip;
// 电话簿
- (void)getAddressBookAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip;
// 日历
- (void)getEventAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip;
// 备忘录
- (void)getReminderAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip;

#ifdef HRAuthorityUseHealthKit
// 健康数据
- (void)getHealthDataAuthority:(HRAuthorityResult)result failureTip:(NSString *)tip;
// 当日步数
- (void)getStepCountInToday:(void(^)(double step, NSError *error))result;
// 当日公里数
- (void)getDistanceInToday:(void(^)(double distance, NSError *error))result;
#endif

// 推送通知
- (void)getNotificationAuthority;
// 定位
- (void)getLocationAuthority:(HRLocationStatusChanged)locationSettingChanged failureTip:(NSString *)tip;
// 获取当前城市位置信息及坐标
- (void)getCurrentCityInfo:(HRCurrentCityInfo)info;

@end
