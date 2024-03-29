//
//  NAURLCenter.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/22.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAURLCenter.h"
#import "AESCrypt.h"

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
        case NARequestURLTypeAPIXA:
            urlString = SERVER_ADDRESS_APIX_A;
            break;
        case NARequestURLTypeAPIXE:
            urlString = SERVER_ADDRESS_APIX_E;
            break;
        case NARequestURLTypeCommunity:
            urlString = SERVER_ADDRESS_COMMUNITY;
            break;
        case NARequestURLTypePhone:
            urlString = SERVER_ADDRESS_PHONE;
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

// 生成美信api接口的model
+ (NAAPIModel *)apiModelWithType:(NAHTTPRequestType)type pathArr:(NSArray *)pathArr param:(NSMutableDictionary *)param rightCode:(NSString *)rightCode {
    NAAPIModel *model = [[NAAPIModel alloc] init];
    model.requestType = type;
    model.pathArr = pathArr;
    model.param = param;
    model.rightCode = rightCode;
    model.requestUrlType = NARequestURLTypeAPI;
    
    return model;
}

// 生成其他类型 api接口的model
+ (NAAPIModel *)apixApiModelWithType:(NAHTTPRequestType)type pathArr:(NSArray *)pathArr param:(NSMutableDictionary *)param urlType:(NARequestURLType)urlType {
    NAAPIModel *model = [[NAAPIModel alloc] init];
    model.requestType = type;
    model.pathArr = pathArr;
    model.param = param;
    model.rightCode = nil;
    model.requestUrlType = urlType;
    
    return model;
}



#pragma mark - <--------------------所有美信的API接口------------------->
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
+ (NAAPIModel *)trustScoreConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"channel"] = @"appios";
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"user_infos", @"trust_score"] param:param rightCode:nil];
}

/** 获取验证码接口 - 注册 */
+ (NAAPIModel *)getSmsConfigForRegisterWithPhoneNumber:(NSString *)phoneNumber {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone_number"] = phoneNumber;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"users", @"register", @"first_send"] param:param rightCode:@"0"];
}

/** 获取验证码接口 - 修改密码 添加银行卡 */
+ (NAAPIModel *)getSmsConfigForResetPasswordWithPhoneNumber:(NSString *)phoneNumber {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone_number"] = phoneNumber;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"users", @"register", @"sendSmsCode"] param:param rightCode:@"0"];
}

/** 获取验证码接口 - 手机登录 */
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

/** 9块9秒杀 商品列表接口 */
+ (NAAPIModel *)goodsListConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"product", @"windows"] param:param rightCode:nil];
}

/** 商品详情接口 */
+ (NAAPIModel *)goodsDetailConfigWithProductID:(NSString *)productID {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    param[@"parent_product_id"] = productID;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"product", @"detail"] param:param rightCode:nil];
}

/** 视频会员列表接口 */
+ (NAAPIModel *)videoVIPListConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"product", @"video_card"] param:param rightCode:nil];
}

/** 银行卡回调接口 */
+ (NAAPIModel *)banksEchoConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"origin"] = @"0";
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"banks", @"echo"] param:param rightCode:nil];
}

#pragma mark - <User>
/** 用户基本信息接口 昵称 头像等 */
+ (NAAPIModel *)mineUserInfoConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"user_infos", @"show"] param:param rightCode:nil];
}

/** 用户vip信息接口 */
+ (NAAPIModel *)mineVipInfoConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"code"] = @"0";
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"vip", @"time"] param:param rightCode:@"0"];
}

/** 用户钱包接口 */
+ (NAAPIModel *)walletConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"red_packet"] param:param rightCode:nil];
}

/** 钱包提现接口 */
+ (NAAPIModel *)encashmentConfigWithMoney:(NSString *)money {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"source"] = @"ios";
    param[@"amount"] = money;
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"red_packet", @"transaction", @"withdraw"] param:param rightCode:nil];
}

/** 用户订单信息接口 */
+ (NAAPIModel *)mineOrderInfoConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"product", @"transactions"] param:param rightCode:@"0"];
}

/** 用户贷款记录接口 */
+ (NAAPIModel *)mineLoanListConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"meixin", @"loan", @"list"] param:param rightCode:@"0"];
}

/** 用户地址接口 */
+ (NAAPIModel *)userAddressConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"address"] param:param rightCode:@"0"];
}

/** 更新地址接口 */
+ (NAAPIModel *)updateAddressConfigWithAddressModel:(NAAddressModel *)addressModel {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"receiver"] = addressModel.receiver;
    param[@"receiver_phone"] = addressModel.receiver_phone;
    param[@"province"] = addressModel.province;
    param[@"city"] = addressModel.city;
    param[@"district"] = addressModel.district;
    param[@"address"] = addressModel.address;
    if (addressModel.id) param[@"id"] = addressModel.id;
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"address", @"new"] param:param rightCode:@"0"];
}

/** 会员礼品接口 */
+ (NAAPIModel *)vipPresentConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"vip", @"gift"] param:param rightCode:@"1"];
}

/** 领取礼品接口 */
+ (NAAPIModel *)receivePresentConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"vip", @"gift", @"add"] param:param rightCode:@"2"];
}

/** 礼品中心背景图接口 */
+ (NAAPIModel *)presentCenterBgConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"vip", @"gift", @"bg"] param:param rightCode:@"2"];
}

/** 分享成功接口 */
+ (NAAPIModel *)shareSuccessConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"share", @"user"] param:param rightCode:@"0"];
}

/** 获取用户认证状态接口 */
+ (NAAPIModel *)authenticationStatusConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"user_credit", @"step"] param:param rightCode:@"0"];
}

/** 保存个人信息接口 */
+ (NAAPIModel *)updateUserInfoConfigWithModel:(NAUserInfoModel *)model {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"nick_name"] = model.nick_name;
    param[@"occupation"] = model.profession;
    param[@"education"] = model.education;
    param[@"marry_info"] = model.marry_info;
    param[@"qq"] = model.qq;
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"user_infos", @"create"] param:param rightCode:nil];
}

/** 验证旧手机号接口 */
+ (NAAPIModel *)checkOldPhoneConfigWithSmsCode:(NSString *)smsCode {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"sms_code"] = smsCode;
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"user_infos", @"sendSmsCode"] param:param rightCode:@"0"];
}
/** 设置新手机号接口 */
+ (NAAPIModel *)setNewPhoneConfigWithPhone:(NSString *)phone smsCode:(NSString *)smsCode {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"sms_code"] = smsCode;
    param[@"new_number"] = phone;
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"user_infos", @"change_number"] param:param rightCode:@"0"];
}

/** 退出登录接口 */
+ (NAAPIModel *)logoutConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"users", @"logout"] param:param rightCode:nil];
}

/** 修改密码接口 */
+ (NAAPIModel *)changePasswordConfigWithPwd:(NSString *)password oldpwd:(NSString *)oldPassword {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"origin"] = @"0";
    param[@"passwd"] = oldPassword;
    param[@"new_passwd"] = password;
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"user_infos", @"change_passwd"] param:param rightCode:@"0"];
}

/** 银行卡管理接口 */
+ (NAAPIModel *)bankCardsConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"banks", @"show"] param:param rightCode:nil];
}

/** 删除银行卡接口 */
+ (NAAPIModel *)deleteBankCardConfigWithCardId:(NSString *)cardId {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"id"] = cardId;
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"banks", @"detail"] param:param rightCode:nil];
}

/** 添加银行卡接口 */
+ (NAAPIModel *)addBankCardConfigWithModel:(NABankCardModel *)model {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"origin"] = @"0";
    param[@"name"] = [NAUserTool getIdName];
    param[@"idnumber"] = [NAUserTool getIdNumber];
    param[@"cardno"] = [AESCrypt encrypt:model.cardNumber password:kAESKey];
    param[@"bank_name"] = model.bank;
    param[@"phone"] = model.cardPhone;
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"banks", @"add"] param:param rightCode:nil];
}

/** 验证绑定银行卡接口 */
+ (NAAPIModel *)validateBankCardConfigWithSmsCode:(NSString *)smsCode phone:(NSString *)phoneNumber cardNumber:(NSString *)cardNumber {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"origin"] = @"0";
    param[@"cardno"] = cardNumber;
    param[@"sms_code"] = smsCode;
    param[@"phone_number"] = phoneNumber;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"banks", @"validate"] param:param rightCode:@"0"];
}

/** 身份认证接口 */
+ (NAAPIModel *)idCardAuthenticationConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"origin"] = @"0";
    param[@"user_name"] = [NAUserTool getIdName];
    param[@"id_number"] = [NAUserTool getIdNumber];
    param[@"nation"] = [NAUserTool getIdNation];
    param[@"detailed_address"] = [NAUserTool getIdDetailedAddress];
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"users", @"idcard_identity"] param:param rightCode:@"0"];
}

/** 脸部识别接口 */
+ (NAAPIModel *)faceIdentityConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"origin"] = @"0";
    param[@"user_name"] = [NAUserTool getIdName];
    param[@"id_number"] = [NAUserTool getIdNumber];
    param[@"nation"] = [NAUserTool getIdNation];
    param[@"detailed_address"] = [NAUserTool getIdDetailedAddress];
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"users", @"face_identity"] param:param rightCode:nil];
}

/** 通讯录认证接口 */
+ (NAAPIModel *)bookAuthenticationConfigWithPhone:(NSString *)phone linkMenStr:(NSString *)linkMenStr {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"user_id"] = @"100999";
    param[@"name"] = @"小明";
    param[@"phone"] = phone;
    param[@"device_id"] = @"100";
    param[@"host_phone"] = @"iOS";
    param[@"linkmen"] = linkMenStr;
    return [self apiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"users", @"contact_identity"] param:param rightCode:nil];
}

/** 用户认证完成接口 */
+ (NAAPIModel *)authenticationSaveConfigWithStep:(NSString *)step token:(NSString *)token {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"step"] = step;
    param[@"token"] = token;
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"license_logging"] param:param rightCode:nil];
}

/** 认证完成后License调用接口 */
+ (NAAPIModel *)authenticationLicenseConfigWith:(NSString *)name {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = [NACommon getToken];
    param[@"name"] = name;
    param[@"user_id"] = [NACommon getUniqueId];
    param[@"success_failure"] = @"success";
    param[@"accounts"] = @"ios爬取方式";
    param[@"remarks"] = @"ios爬取方式";
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"user_credit", @"save"] param:param rightCode:@"0"];
}



/**
 苹果内购VIP会员后 后台验证接口
 
 @param receipt 内购的收据信息
 @param isSandBox 是否是测试
 @param imageId VIP会员页的imageId
 @return 内购会员后验证接口的NAAPIModel
 */
+ (NAAPIModel *)buyVipVerifyConfigWithReceipt:(NSString *)receipt isSandBox:(BOOL)isSandBox imageId:(NSString *)imageId {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"receipt"] = receipt;
    param[@"is_sandbox"] = @(isSandBox?1:0);
    param[@"img_id"] = imageId;
    param[@"apix_token"] = [NACommon getToken];
    return [self apiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"api", @"vip", @"ios", @"add"] param:param rightCode:@"0"];
}


#pragma mark - <--------------------所有其他的API接口------------------->
/** 身份证识别接口 */
+ (NAAPIModel *)idCardRecognitionConfigWithPicDataStr:(NSString *)picDataStr picType:(NSString *)picType {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cmd"] = @"idcard_front";
    param[@"pictype"] = picType;
    param[@"pic"] = picDataStr;
    return [self apixApiModelWithType:NAHTTPRequestTypePost pathArr:@[@"apixlab", @"idcardrecog", @"idcardimage"] param:param urlType:NARequestURLTypeAPIXA];
}

/** 淘宝认证获取url接口 */
+ (NAAPIModel *)tbAuthenticationUrlConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"callback_url"] = kAuthenticationCallbackUrl;
    param[@"success_url"] = kAuthenticationSuccessUrl;
    param[@"failed_url"] = kAuthenticationFailedUrl;
    return [self apixApiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"apixanalysis", @"tb", @"grant", @"ele_business", @"taobao", @"pages"] param:param urlType:NARequestURLTypeAPIXE];
}

/** 京东认证获取url接口 */
+ (NAAPIModel *)jdAuthenticationUrlConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"callback_url"] = kAuthenticationCallbackUrl;
    param[@"success_url"] = kAuthenticationSuccessUrl;
    param[@"failed_url"] = kAuthenticationFailedUrl;
    return [self apixApiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"apixanalysis", @"jd", @"grant", @"ele_business", @"jingdong", @"jd", @"page"] param:param urlType:NARequestURLTypeAPIXE];
}

/** 淘宝认证获取url接口 */
+ (NAAPIModel *)serviceAuthenticationUrlConfig {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"callback_url"] = kAuthenticationCallbackUrl;
    param[@"success_url"] = kAuthenticationSuccessUrl;
    param[@"failed_url"] = kAuthenticationFailedUrl;
    return [self apixApiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"apixanalysis", @"mobile", @"yys", @"phone", @"carrier", @"page"] param:param urlType:NARequestURLTypeAPIXE];
}

/** 发帖接口 */
+ (NAAPIModel *)postArticleConfigWithTitle:(NSString *)title body:(NSString *)body {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"name"] = [NAUserTool getPhoneNumber];
    param[@"topic[body]"] = body;
    param[@"topic[title]"] = title;
    param[@"topic[node_id]"] = @"28";
    return [self apixApiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"bbs_create_topic"] param:param urlType:NARequestURLTypeCommunity];
}


/**
 评论、回复接口

 @param body 内容
 @param commentID 评论id
 @return NAAPIModel
 */
+ (NAAPIModel *)commentConfigWithBody:(NSString *)body commentID:(NSString *)commentID {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"name"] = [NAUserTool getPhoneNumber];
    param[@"reply[body]"] = body;
    param[@"id"] = commentID;
    return [self apixApiModelWithType:NAHTTPRequestTypePost pathArr:@[@"api", @"bbs_create"] param:param urlType:NARequestURLTypeCommunity];
}

/** 获取号码归属地接口 */
+ (NAAPIModel *)phoneAddressConfigWithPhoneNumber:(NSString *)phoneNumber {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = phoneNumber;
    return [self apixApiModelWithType:NAHTTPRequestTypeGet pathArr:@[@"life", @"phone"] param:param urlType:NARequestURLTypePhone];
}


#pragma mark - <---------------------所有的H5--------------------->
/** 确认订单页 */
+ (NSString *)confirmOrderH5UrlWithModel:(NAConfirmOrderModel *)orderModel {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    param[@"ptypeId"] = orderModel.ptypeId;
    param[@"ptype"] = orderModel.ptype;
    param[@"title"] = orderModel.title;
    param[@"img"] = orderModel.img;
    param[@"money"] = orderModel.money;
    param[@"orderType"] = orderModel.orderType;
    if (orderModel.phone_num) param[@"phone_num"] = orderModel.phone_num;
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"confirmOrder"]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

/** 使用支付宝支付的美信会员页 */
+ (NSString *)vipH5UrlWithIsFromGiftCenter:(BOOL)isFromGiftCenter {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    param[@"type"] = @"1";
    param[@"device"] = @"app";
    if (isFromGiftCenter) param[@"source"] = @"giftcenter";
    else param[@"source"] = @"my";
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"strategy", @"vipBuy"]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

/* 使用apple内购的美信会员页 */
+ (NSString *)vipiOSH5UrlWithIsFromGiftCenter:(BOOL)isFromGiftCenter {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    if (isFromGiftCenter) param[@"source"] = @"giftcenter";
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"strategy", @"vipBuy_ios"]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

/* 信用体检页 */
+ (NSString *)creditReportH5Url {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"creditexam"]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

/* 常见问题页 */
+ (NSString *)commonQuestionsH5Url {
    return [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"commonquestion"]];
}

/** 美信说-攻略 */
+ (NSString *)EssenceH5Url {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    param[@"device"] = @"app";
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"strategy"]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

/** 美信说-社区 */
+ (NSString *)communityH5Url {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"device"] = @"app";
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"forum"]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

/** 我要赚钱页 */
+ (NSString *)makeMoneyH5Url {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"make_money"]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

/** 分享出去的商品详情页 */
+ (NSString *)sharedGoodsDetailH5UrlWithGoodsID:(NSString *)goodsID {
    return [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"shopDetail", goodsID]];
}

/** 无息贷款页 */
+ (NSString *)loanNoInterestH5Url {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    param[@"device"] = @"app";
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"loannointerest"]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

/** 贷款审核中页面 */
+ (NSString *)loanReviewH5Url {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"loanreview"]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

/** 借款协议页 */
+ (NSString *)loanProtocolH5Url {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"loanAgreement"]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

/** 央行征信页 */
+ (NSString *)creditAuthenticationH5Url {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"pbc"]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

/** 学信网认证页 */
+ (NSString *)schoolAuthenticationH5Url {
    return [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"degrees"]];
}

/** 公积金认证页 */
+ (NSString *)houseAuthenticationH5Url {
    return [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", @"bjfunds"]];
}

/** 借贷历史认证页 */
+ (NSString *)loanAuthenticationH5Url:(NSInteger)step {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [NACommon getToken];
    NSString *path2 = @"chistory";
    if (step == 2) path2 = @"chistorytwo";
    else if (step == 3) path2 = @"chistorythree";
    NSString *urlStr = [self urlWithType:NARequestURLTypeH5 pathArray:@[@"webapp", path2]];
    NSString *parameterStr =  [self parameterStringWithParam:param];
    return [NSString stringWithFormat:@"%@?%@", urlStr, parameterStr];
}

@end
