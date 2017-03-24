//
//  HRSecurityManager.h

//
//  Created by 许昊然 on 16/7/21.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRSecurityManager : NSObject
/**
 *  获取deviceid
 *
 *  @return diviceid
 */
+ (NSString *)getDeviceId;
/**
 *  存储token
 *
 *  @param token 账户token
 *
 *  @return is or not
 */
+ (BOOL)storeToken:(NSString *)token;
/**
 *  清空token
 *
 *  @return is or not
 */
+ (BOOL)clearToken;
/**
 *  获取本地token
 *
 *  @return token
 */
+ (NSString *)getToken;
/**
 *  存储对应账户的密码
 *
 *  @param username 用户名
 *  @param password 密码
 *
 *  @return is or not
 */
+ (BOOL)storePasswordWithUserName:(NSString *)username password:(NSString *)password;
/**
 *  删除对应账户的密码
 *
 *  @param username 用户名
 *
 *  @return is or not
 */
+ (BOOL)deletePasswordWithUserName:(NSString *)username;
/**
 *  拿到对应用户名的密码
 *
 *  @param username 用户名
 *
 *  @return 密码
 */
+ (NSString *)getPasswordWithUserName:(NSString *)username;

@end
