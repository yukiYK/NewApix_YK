//
//  NAURLCenter.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/22.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAURLCenter.h"

@implementation NAURLCenter

/**
 拼接url
 
 @param urlType 请求的类型  api还是h5 等
 @param pathArray 路径  a/b/c...
 @return 拼接好的完整urlString
 */
+ (NSString *)urlWithType:(NARequestURLType)urlType pathArray:(NSArray *)pathArray {
    
    NSString *urlString = @"";
    switch (urlType) {
        case NARequestURLTypeAPI:
            urlString = SERVER_ADDRESS_API;
            break;
        case NARequestURLTypeH5:
            urlString = SERVER_ADDRESS_H5;
            break;
        default:
            break;
    }
    
    if (pathArray != nil && pathArray.count > 0) {
        for (NSString *path in pathArray) {
            urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
        }
    }
    NSLog(@"%@", urlString);
    return urlString;
}

+ (NSString *)parameterStringWithParam:(NSDictionary *)param {
    if (!param) return @"";
    if (param.count <= 0) return @"";
    
    NSString *parmaeterStr = @"";
    NSArray *allKeys = param.allKeys;
    for (int i=0; i<allKeys.count; i++) {
        NSString *key = allKeys[i];
        NSString *formatStr = [NSString stringWithFormat:@"%@=%@&", key, param[key]];
        if (i == allKeys.count - 1) formatStr = [NSString stringWithFormat:@"%@=%@", key, param[key]];
        parmaeterStr = [parmaeterStr stringByAppendingString:formatStr];
    }
    return parmaeterStr;
}

+ (NAAPIModel *)apiModelWithType:(NAHTTPRequestType)type pathArr:(NSArray *)pathArr param:(NSMutableDictionary *)param rightCode:(NSString *)rightCode {
    NAAPIModel *model = [[NAAPIModel alloc] init];
    model.requestType = type;
    model.pathArr = pathArr;
    model.param = param;
    
    return model;
}



#pragma mark - <--------------------所有的API接口------------------->
/** 审核开关接口 */
+ (NAAPIModel *)onOrOffConfigWithName:(NSString *)name origin:(NSString *)origin {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"name"] = name;
    param[@"origin"] = origin;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"control"] param:param rightCode:@"0"];
}

#pragma mark - <Login Register>
/** 登录接口 */
+ (NAAPIModel *)loginConfigWithPhone:(NSString *)phoneNumber password:(NSString *)password {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"origin"] = @"0";
    param[@"phone_number"] = phoneNumber;
    param[@"passwd"] = password;
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"users", @"login"] param:param rightCode:@"0"];
}

/** 手机登录接口 */
+ (NAAPIModel *)phoneLoginConfigWithPhone:(NSString *)phoneNumber sms:(NSString *)sms {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"sms"] = sms;
    param[@"phone_number"] = phoneNumber;
    param[@"port_type"] = @"Ios";
    param[@"reg_location"] = [NAUserTool getLocation];
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"users", @"registration", @"v2"] param:param rightCode:@"0"];
}

/** 注册接口 */
+ (NAAPIModel *)registerConfigWithPhone:(NSString *)phoneNumber password:(NSString *)password sms:(NSString *)sms imgSms:(NSString *)imgSms imgSmsKey:(NSString *)imgSmsKey {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"origin"] = @"2";
    param[@"phone_number"] = phoneNumber;
    param[@"passwd"] = password;
    param[@"sms_code"] = sms;
    param[@"captcha"] = imgSms;
    param[@"captcha_key"] = imgSmsKey;
    param[@"location"] = [NAUserTool getLocation];
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"users", @"register"] param:param rightCode:@"0"];
}

/** 用户信用分数接口 */
+ (NAAPIModel *)trustScoreConfigWithToken:(NSString *)token {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = token;
    param[@"channel"] = @"appios";
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"user_infos", @"trust_score"] param:param rightCode:nil];
}

/** 获取验证码接口-注册 */
+ (NAAPIModel *)getSmsConfigForRegisterWithPhoneNumber:(NSString *)phoneNumber {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone_number"] = phoneNumber;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"users", @"register", @"first_send"] param:param rightCode:@"0"];
}

/** 获取验证码接口-修改密码 */
+ (NAAPIModel *)getSmsConfigForResetPasswordWithPhoneNumber:(NSString *)phoneNumber {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone_number"] = phoneNumber;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"users", @"register", @"sendSmsCode"] param:param rightCode:@"0"];
}

/** 获取验证码接口-手机登录 */
+ (NAAPIModel *)getSmsConfigForPhoneLoginWithPhoneNumber:(NSString *)phoneNumber {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone_number"] = phoneNumber;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"users", @"registration", @"sms"] param:param rightCode:@"0"];
}

/** 获取图片验证码接口 */
+ (NAAPIModel *)getImgSmsConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = @"";
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"simple_captcha"] param:param rightCode:nil];
}

/** 重置密码接口 */
+ (NAAPIModel *)resetPasswordConfigWithPhone:(NSString *)phoneNumber password:(NSString *)password sms:(NSString *)sms{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"origin"] = @"0";
    param[@"phone"] = phoneNumber;
    param[@"passwd"] = password;
    param[@"sms_code"] = sms;
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"user_infos", @"reset_passwd"] param:param rightCode:@"0"];
}

#pragma mark - <MainPage>
/** 首页卡片接口 */
+ (NAAPIModel *)mainPageCardConfigWithVersion:(NSString *)version {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"version"] = version;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"cards"] param:param rightCode:@"0"];
}

#pragma mark - <User>
/** 用户基本信息接口 昵称 头像等 */
+ (NAAPIModel *)mineUserInfoConfigWithToken:(NSString *)token {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = token;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"user_infos", @"show"] param:param rightCode:nil];
}

/** 用户vip信息接口 */
+ (NAAPIModel *)mineVipInfoConfigWithToken:(NSString *)token {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = token;
    param[@"code"] = @"0";
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"vip", @"time"] param:param rightCode:@"0"];
}

/** 用户订单信息接口 */
+ (NAAPIModel *)mineOrderInfoConfigWithToken:(NSString *)token {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = token;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"product", @"transactions"] param:param rightCode:@"0"];
}

/** 用户贷款记录接口 */
+ (NAAPIModel *)mineLoanListConfigWithToken:(NSString *)token {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = token;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"meixin", @"loan", @"list"] param:param rightCode:@"0"];
}



#pragma mark - <---------------------所有的H5--------------------->
+ (NSString *)vipH5URLWithToken:(NSString *)token {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    NSString *urlStr = [NAURLCenter urlWithType:NARequestURLTypeH5 pathArray:@[@"", @""]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

+ (NSString *)vipiOSH5UrlWithToken:(NSString *)token {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    NSString *urlStr = [NAURLCenter urlWithType:NARequestURLTypeH5 pathArray:@[@"", @""]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

@end
