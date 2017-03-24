//
//  HRSecurityManager.m

//
//  Created by 许昊然 on 16/7/21.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "HRSecurityManager.h"
#import "SAMKeychain.h"

static NSString *kKeychainDeviceId  = @"HRKeychainDeviceId";
static NSString *kKeychainToken     = @"HRKeychainToken";

@implementation HRSecurityManager

+ (NSString *)getDeviceId {
    NSString *localDeviceId = [SAMKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier] account:kKeychainDeviceId];
    if (!localDeviceId) {
        // 保存设备号
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef deviceId = CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        [SAMKeychain setPassword:[NSString stringWithFormat:@"%@", deviceId] forService:[[NSBundle mainBundle] bundleIdentifier] account:kKeychainDeviceId];
        localDeviceId = [NSString stringWithFormat:@"%@", deviceId];
        CFRelease(deviceId);
    }
    return localDeviceId;
}

+ (BOOL)storeToken:(NSString *)token {
    return [SAMKeychain setPassword:token forService:[[NSBundle mainBundle] bundleIdentifier] account:kKeychainToken];
}

+ (BOOL)clearToken {
    return [SAMKeychain deletePasswordForService:[[NSBundle mainBundle] bundleIdentifier] account:kKeychainToken];
}

+ (NSString *)getToken {
    return [SAMKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier] account:kKeychainToken];
}

+ (BOOL)storePasswordWithUserName:(NSString *)username password:(NSString *)password {
    return [SAMKeychain setPassword:password forService:[[NSBundle mainBundle] bundleIdentifier] account:username];
}

+ (BOOL)deletePasswordWithUserName:(NSString *)username {
    return [SAMKeychain deletePasswordForService:[[NSBundle mainBundle] bundleIdentifier] account:username];
}

+ (NSString *)getPasswordWithUserName:(NSString *)username {
    return [SAMKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier] account:username];
}

@end
