//
//  NSString+NAExtension.h
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NAExtension)

/** 用于生成文件在caches目录中的路径 */
- (instancetype)cachePath;

/** 用于生成文件在document目录中的路径 */
- (instancetype)documentPath;

/** 用于生成文件在tmp目录中的路径 */
- (instancetype)tmpPath;

/** 获得当前文件大小 */
- (unsigned long long)fileSize;

/** MD5加密 */
- (NSString *)stringFromMD5;


/** 用于生成文件在caches目录中default文件夹下的路径 */
- (instancetype)cachePathDefault;

/**
 *  判断字符串里面是否含有emoji
 */
- (BOOL)stringContainsEmoji;

/** 判断string是否为空 */
- (BOOL)checkEmpty;

@end
