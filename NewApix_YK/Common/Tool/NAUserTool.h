//
//  NAUserTool.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/22.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAUserTool : NSObject

+ (NSString *)getNick;
+ (void)saveNick:(NSString *)nick;

+ (NSString *)getPhoneNunber;
+ (void)savePhoneNumber:(NSString *)phoneNumber;

+ (NSString *)getAvatar;
+ (void)saveAvatar:(NSString *)avatar;

+ (NSString *)getIdNumber;
+ (void)saveIdNumber:(NSString *)idNumber;

+ (NSString *)getTrustScore;
+ (void)saveTrustSocre:(NSString *)trustScore;

+ (NSString *)getLocation;
+ (void)saveLocation:(NSString *)location;

+ (NSString *)getDeviceId;
+ (void)saveDeviceId:(NSString *)deviceId;

+ (NSString *)getSystemVersion;
+ (void)saveSystemVersion:(NSString *)systemVersion;

+ (NSString *)getEquipmentType;
+ (void)saveEquipmentType:(NSString *)equipmentType;

/** 清除跟用户相关的userDefaults */
+ (void)removeAllUserDefaults;

@end
