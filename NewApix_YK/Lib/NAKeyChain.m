//
//  NAKeyChain.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/24.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAKeyChain.h"
#import <Security/Security.h>

static NSString * const kDicKey = @"com.heige.dicKey";

@implementation NAKeyChain

/**
 存储密匙到字符串
 
 @param value 密匙value
 @param key 密匙的key
 */
+ (void)saveKeyChainValue:(NSString *)value key:(NSString *)key {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic setObject:value forKey:kDicKey];
    [self save:key data:tempDic];
}


/**
 获取存储的密匙
 
 @param key 密匙的key
 @return 密匙value
 */
+ (NSString *)loadKeyChainWithKey:(NSString *)key {
    NSMutableDictionary *tempDic = (NSMutableDictionary *)[self load:key];
    return [tempDic objectForKey:kDicKey];
}

/**
 *  删除 KeyChain 信息
 */
+ (void)deleteKeyChainWithKey:(NSString *)key {
    [self delete:key];
}

#pragma mark - <Private Method>
/** 根据account获取一个keyChain
 *  其实获取一个keyChain需要service、account、accessGroup。
 *  只不过service accessGroup我们做了默认
 */
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)account {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            kKeyChain, (id)kSecAttrService,
            account, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)account data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:account];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)account {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:account];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", account, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)account {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:account];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
