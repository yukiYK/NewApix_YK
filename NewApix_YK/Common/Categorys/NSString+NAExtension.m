//
//  NSString+NAExtension.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NSString+NAExtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NAExtension)

- (instancetype)cachePath {
    // 1. 获取caches目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@/%@",path,self);
    // 2. 生成绝对路径
    return [path stringByAppendingPathComponent:[self lastPathComponent]];
}

- (instancetype)cachePathDefault {
    // 1. 获取caches目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *defaultPath = [path stringByAppendingPathComponent:@"default"];
    
    NSString *wanplusDir = [NSString stringWithFormat:@"%@/wanplus",defaultPath];
    
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:wanplusDir isDirectory:&isDir];
    
    if (!(isDir == YES && existed == YES)) {
        [fileManager createDirectoryAtPath:wanplusDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 2. 生成绝对路径
    return [wanplusDir stringByAppendingPathComponent:[self lastPathComponent]];
}

- (instancetype)documentPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:[self lastPathComponent]];
}

- (instancetype)tmpPath {
    NSString *path = NSTemporaryDirectory();
    return [path stringByAppendingPathComponent:[self lastPathComponent]];
}



- (unsigned long long)fileSize {
    // get filemanager
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // is Directory? (directory or file)
    BOOL isDirectory = NO;
    
    // judge the directory path is correct
    BOOL exsits = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    
    // if the path is false
    if (!exsits)  return 0;
    
    // is Directory
    if (isDirectory) {
        // var totalSize
        unsigned long long fileSize = 0;
        
        // for in all files in directory
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        
        /* 这个enumerator会把传入的文件夹里面的所有路径返回回来
         例如：
         Programming
         Programming/.DS_Store
         Programming/[Python技术手册(第2版)].（美）马特利.扫描版(ED2000.COM).pdf
         Programming/[搬书匠][Python In A Nutshell 2nd Edition].2006.英文版.pdf
         */
        
        for (NSString *subpath in enumerator) {
            // full subpath
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            
            /* attributesOfItemAtPath:error: 方法返回的字典：
             {
             NSFileCreationDate = "2015-09-03 12:17:28 +0000";
             NSFileExtensionHidden = 0;
             NSFileGroupOwnerAccountID = 20;
             NSFileGroupOwnerAccountName = staff;
             NSFileModificationDate = "2015-09-23 11:40:52 +0000";
             NSFileOwnerAccountID = 501;
             NSFilePosixPermissions = 493;
             NSFileReferenceCount = 12;
             NSFileSize = 408;
             NSFileSystemFileNumber = 7117682;
             NSFileSystemNumber = 16777220;
             NSFileType = NSFileTypeDirectory;
             }
             */
            
            // filesize的作用：Returns the value for the key NSFileSize.
            fileSize += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
        
        return fileSize;
        
    }
    
    // is file
    return [mgr attributesOfItemAtPath:self error:nil].fileSize;
    
}

// MD5加密方法
- (NSString *)stringFromMD5 {
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}



- (BOOL)stringContainsEmoji {
    
    NSArray *array = @[@"，", @"➋", @"➌", @"➍", @"➎", @"➏", @"➐", @"➑", @"➒"];
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              
                              NSLog(@"%hu",hs);
                              
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              }
                              else {
                                  // 补充：防止iOS自带的九宫格输入法被阻止
                                  if ([array containsObject:self]) {
                                      returnValue = NO;
                                  }
                                  else if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    
    return returnValue;
}

- (BOOL)checkEmpty {
    if (self == nil || [self isEqualToString:@""] || [self isEqualToString:@"<null>"] || [self isEqualToString:@"(null)"] || [self isEqualToString:@"null"] || [self isEqualToString:@"NULL"]) {
        return YES;
    }
    else return NO;
}

@end
