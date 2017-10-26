//
//  NAUserTool.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/22.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAUserTool.h"

@implementation NAUserTool

+ (NSString *)getNick {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsNick];
}
+ (void)saveNick:(NSString *)nick {
    [[NSUserDefaults standardUserDefaults] setObject:nick forKey:kUserDefaultsNick];
}

+ (NSString *)getPhoneNunber {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsPhone];
}
+ (void)savePhoneNumber:(NSString *)phoneNumber {
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:kUserDefaultsPhone];
}

+ (NSString *)getAvatar {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAvatar];
}
+ (void)saveAvatar:(NSString *)avatar {
    [[NSUserDefaults standardUserDefaults] setObject:avatar forKey:kUserDefaultsAvatar];
}

+ (NSString *)getIdName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsIdName];
}
+ (void)saveIdName:(NSString *)idName {
    [[NSUserDefaults standardUserDefaults] setObject:idName forKey:kUserDefaultsIdName];
}

+ (NSString *)getIdNumber {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsIdNumber];
}
+ (void)saveIdNumber:(NSString *)idNumber {
    [[NSUserDefaults standardUserDefaults] setObject:idNumber forKey:kUserDefaultsIdNumber];
}

/** 身份证上的国籍 */
+ (NSString *)getIdNation {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsIdNation];
}
+ (void)saveIdNation:(NSString *)idNation {
    [[NSUserDefaults standardUserDefaults] setObject:idNation forKey:kUserDefaultsIdNation];
}

/** 身份证上的地址 */
+ (NSString *)getIdDetailedAddress {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsIdDetailedAddress];
}
+ (void)saveIdDetailedAddress:(NSString *)idAddress {
    [[NSUserDefaults standardUserDefaults] setObject:idAddress forKey:kUserDefaultsIdDetailedAddress];
}

+ (NSString *)getTrustScore {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsTrustScore];
}
+ (void)saveTrustSocre:(NSString *)trustScore {
    [[NSUserDefaults standardUserDefaults] setObject:trustScore forKey:kUserDefaultsTrustScore];
}

+ (NSString *)getLocation {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsLocation];
}
+ (void)saveLocation:(NSString *)location {
    [[NSUserDefaults standardUserDefaults] setObject:location forKey:kUserDefaultsLocation];
}

+ (NSString *)getDeviceId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsDeviceId];
}
+ (void)saveDeviceId:(NSString *)deviceId {
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:kUserDefaultsDeviceId];
}

+ (NSString *)getSystemVersion {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsSystemVersion];
}
+ (void)saveSystemVersion:(NSString *)systemVersion {
    [[NSUserDefaults standardUserDefaults] setObject:systemVersion forKey:kUserDefaultsSystemVersion];
}

+ (NSString *)getEquipmentType {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsEquipmentType];
}
+ (void)saveEquipmentType:(NSString *)equipmentType {
    [[NSUserDefaults standardUserDefaults] setObject:equipmentType forKey:kUserDefaultsEquipmentType];
}

/** 性别 */
+ (NSString *)getSex {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsSex];
}
+ (void)saveSex:(NSString *)sex {
    [[NSUserDefaults standardUserDefaults] setObject:sex forKey:kUserDefaultsSex];
}

/** 用户VIP状态 */
+ (NAUserStatus)getUserStatus {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsUserStatus];
}
+ (void)saveUserStatus:(NAUserStatus)userStatus {
    [[NSUserDefaults standardUserDefaults] setInteger:userStatus forKey:kUserDefaultsUserStatus];
}

/** 清除跟用户相关的userDefaults */
+ (void)removeAllUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUserDefaultsToken];
    [defaults removeObjectForKey:kUserDefaultsNick];
    [defaults removeObjectForKey:kUserDefaultsAvatar];
    [defaults removeObjectForKey:kUserDefaultsIdName];
    [defaults removeObjectForKey:kUserDefaultsIdNumber];
    [defaults removeObjectForKey:kUserDefaultsPhone];
    [defaults removeObjectForKey:kUserDefaultsTrustScore];
    [defaults removeObjectForKey:kUserDefaultsSex];
}

@end
