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

+ (NSString *)getAvatar;
+ (void)saveAvatar:(NSString *)avatar;

+ (NSString *)getIdNumber;
+ (void)saveIdNumber:(NSString *)idNumber;

+ (NSString *)getLocation;
+ (void)saveLocation:(NSString *)location;

/** 清除跟用户相关的userDefaults */
+ (void)removeAllUserDefaults;

@end
