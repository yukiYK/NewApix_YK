//
//  NAUserTool.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/22.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAUserTool : NSObject

/** 昵称 */
+ (NSString *)getNick;
+ (void)saveNick:(NSString *)nick;

/** 手机号 */
+ (NSString *)getPhoneNunber;
+ (void)savePhoneNumber:(NSString *)phoneNumber;

/** 头像地址 */
+ (NSString *)getAvatar;
+ (void)saveAvatar:(NSString *)avatar;

/** 真实姓名 */
+ (NSString *)getIdName;
+ (void)saveIdName:(NSString *)idName;

/** 身份证号 AES编码后的 */
+ (NSString *)getIdNumber;
+ (void)saveIdNumber:(NSString *)idNumber;

/** 信用分数 */
+ (NSString *)getTrustScore;
+ (void)saveTrustSocre:(NSString *)trustScore;

/** 地址 */
+ (NSString *)getLocation;
+ (void)saveLocation:(NSString *)location;

/** 设备id */
+ (NSString *)getDeviceId;
+ (void)saveDeviceId:(NSString *)deviceId;

/** 系统版本 */
+ (NSString *)getSystemVersion;
+ (void)saveSystemVersion:(NSString *)systemVersion;

/** 设备类型 */
+ (NSString *)getEquipmentType;
+ (void)saveEquipmentType:(NSString *)equipmentType;

/** 性别 男 女 */
+ (NSString *)getSex;
+ (void)saveSex:(NSString *)sex;


/** 清除跟用户相关的userDefaults */
+ (void)removeAllUserDefaults;

@end
