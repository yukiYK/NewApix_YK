//
//  NAURLCenter.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/22.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NAAPIModel.h"

typedef NS_ENUM(NSInteger, NARequestURLType) {
    NARequestURLTypeAPI,
    NARequestURLTypeH5
};

/** 接口管理类 获取各个接口的配置 */
@interface NAURLCenter : NSObject

/**
 拼接url
 
 @param urlType 类型  api还是h5 等
 @param pathArray 路径  a/b/c...
 @return 拼接好的完整urlString
 */
+ (NSString *)urlWithType:(NARequestURLType)urlType pathArray:(NSArray *)pathArray;


#pragma mark - <---------------------所有的API--------------------->
/** 审核开关接口 */
+ (NAAPIModel *)onOrOffConfigWithName:(NSString *)name origin:(NSString *)origin;

// --------------------------------登录 注册-------------------------
/** 登录接口 */
+ (NAAPIModel *)loginConfigWithPhone:(NSString *)phoneNumber password:(NSString *)password;
/** 手机登录接口 */
+ (NAAPIModel *)phoneLoginConfigWithPhone:(NSString *)phoneNumber sms:(NSString *)sms;
/**
 注册接口

 @param phoneNumber 手机号
 @param password 密码 加密后的
 @param sms 验证码
 @param imgSms 图片验证码
 @param imgSmsKey 图片验证码的key
 @return 注册接口的NAAPIModel
 */
+ (NAAPIModel *)registerConfigWithPhone:(NSString *)phoneNumber
                               password:(NSString *)password
                                    sms:(NSString *)sms
                                 imgSms:(NSString *)imgSms
                              imgSmsKey:(NSString *)imgSmsKey;
/** 用户信用分数接口 */
+ (NAAPIModel *)trustScoreConfig;
/** 获取验证码接口-注册 */
+ (NAAPIModel *)getSmsConfigForRegisterWithPhoneNumber:(NSString *)phoneNumber;
/** 获取验证码接口-修改密码 */
+ (NAAPIModel *)getSmsConfigForResetPasswordWithPhoneNumber:(NSString *)phoneNumber;
/** 获取验证码接口-手机登录 */
+ (NAAPIModel *)getSmsConfigForPhoneLoginWithPhoneNumber:(NSString *)phoneNumber;
/** 获取图片验证码接口 */
+ (NAAPIModel *)getImgSmsConfig;
/** 重置密码接口 */
+ (NAAPIModel *)resetPasswordConfigWithPhone:(NSString *)phoneNumber password:(NSString *)password sms:(NSString *)sms;

// --------------------------------首页------------------------------
/** 首页卡片接口 */
+ (NAAPIModel *)mainPageCardConfigWithVersion:(NSString *)version;

// ---------------------------------会员中心----------------------------
/** 用户基本信息接口 昵称 头像等 */
+ (NAAPIModel *)mineUserInfoConfig;
/** 用户vip信息接口 */
+ (NAAPIModel *)mineVipInfoConfig;
/** 用户订单信息接口 */
+ (NAAPIModel *)mineOrderInfoConfig;
/** 用户贷款记录接口 */
+ (NAAPIModel *)mineLoanListConfig;
/** 用户地址接口 */
+ (NAAPIModel *)userAddressConfig;
/** 更新地址接口 */
+ (NAAPIModel *)updateAddressConfigWithReceiver:(NSString *)receiver
                                  receiverPhone:(NSString *)receiverPhone
                                       province:(NSString *)province
                                           city:(NSString *)city
                                       district:(NSString *)district
                                        address:(NSString *)address
                                             id:(NSString *)addressId;
/** 会员礼品接口 */
+ (NAAPIModel *)vipPresentConfig;
/** 领取礼品接口 */
+ (NAAPIModel *)receivePresentConfig;
/** 礼品中心背景图接口 */
+ (NAAPIModel *)presentCenterBgConfig;
/** 分享成功接口 */
+ (NAAPIModel *)shareSuccessConfig;
/**
 苹果内购VIP会员后 后台验证接口

 @param receipt 内购的收据信息
 @param isSandBox 是否是测试
 @param imageId VIP会员页的imageId
 @return 内购会员后验证接口的NAAPIModel
 */
+ (NAAPIModel *)buyVipVerifyConfigWithReceipt:(NSString *)receipt isSandBox:(BOOL)isSandBox imageId:(NSString *)imageId;

#pragma mark - <---------------------所有的H5--------------------->
/** 使用支付宝支付的美信会员页 */
+ (NSString *)vipH5UrlWithIsFromGiftCenter:(BOOL)isFromGiftCenter;
/* 使用apple内购的美信会员页 */
+ (NSString *)vipiOSH5UrlWithIsFromGiftCenter:(BOOL)isFromGiftCenter;
/* 信用体检页 */
+ (NSString *)creditReportH5Url;

@end
