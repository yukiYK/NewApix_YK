//
//  NACommon.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NACommon.h"


/**
 公共类，用来放一些全局方法
 */
@implementation NACommon

+ (NSString *)getToken {
    NSString *token = @"";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"login"]) {
        token = [defaults objectForKey:@"login"];
    }
    else if ([defaults objectForKey:@"register"]) {
        token = [defaults objectForKey:@"register"];
    }
    return token;
}


+ (void)setToken:(NSString *)token {
}


@end
