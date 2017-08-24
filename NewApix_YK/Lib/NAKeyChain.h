//
//  NAKeyChain.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/24.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 *  其实就是iOS或macOS的钥匙串，
 *  我把它封装成了key-value形式  key：account  value：password
 *  可以当成userDefault使用，区别是：即使app被删了，这些数据依然存在
 */
@interface NAKeyChain : NSObject


/**
 存储密匙到字符串

 @param value 密匙value
 @param key 密匙的key
 */
+ (void)saveKeyChainValue:(NSString *)value key:(NSString *)key;


/**
 获取存储的密匙

 @param key 密匙的key
 @return 密匙value
 */
+ (NSString *)loadKeyChainWithKey:(NSString *)key;

/**
 *  删除 KeyChain 信息
 */
+ (void)deleteKeyChainWithKey:(NSString *)key;

@end
