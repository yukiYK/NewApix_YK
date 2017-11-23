//
//  NAURLCenter.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/22.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NAAPIModel.h"
#import "NAAddressModel.h"
#import "NAUserInfoModel.h"
#import "NABankCardModel.h"
#import "NAConfirmOrderModel.h"

/** 接口管理类 获取各个接口的配置 */
@interface NAURLCenter : NSObject

/**
 拼接url
 
 @param urlType 类型  api还是h5 等
 @param pathArray 路径  a/b/c...
 @return 拼接好的完整urlString
 */
+ (NSString *)urlWithType:(NARequestURLType)urlType pathArray:(NSArray *)pathArray;


#pragma mark - <---------------------所有美信的API接口--------------------->
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
/** 获取验证码接口 - 注册 */
+ (NAAPIModel *)getSmsConfigForRegisterWithPhoneNumber:(NSString *)phoneNumber;
/** 获取验证码接口 - 修改密码 添加银行卡 */
+ (NAAPIModel *)getSmsConfigForResetPasswordWithPhoneNumber:(NSString *)phoneNumber;
/** 获取验证码接口 - 手机登录 */
+ (NAAPIModel *)getSmsConfigForPhoneLoginWithPhoneNumber:(NSString *)phoneNumber;
/** 获取图片验证码接口 */
+ (NAAPIModel *)getImgSmsConfig;
/** 重置密码接口 */
+ (NAAPIModel *)resetPasswordConfigWithPhone:(NSString *)phoneNumber password:(NSString *)password sms:(NSString *)sms;

// --------------------------------首页------------------------------
/** 首页卡片接口 */
+ (NAAPIModel *)mainPageCardConfigWithVersion:(NSString *)version;
/** 9块9秒杀 商品列表接口 */
+ (NAAPIModel *)goodsListConfig;
/** 商品详情接口 */
+ (NAAPIModel *)goodsDetailConfigWithProductID:(NSString *)productID;

// ---------------------------------会员中心----------------------------
/** 用户基本信息接口 昵称 头像等 */
+ (NAAPIModel *)mineUserInfoConfig;
/** 用户vip信息接口 */
+ (NAAPIModel *)mineVipInfoConfig;
/** 用户钱包接口 */
+ (NAAPIModel *)walletConfig;
/**
 钱包提现接口

 @param money 提现金额
 @return NAAPIModel对象
 */
+ (NAAPIModel *)encashmentConfigWithMoney:(NSString *)money;
/** 用户订单信息接口 */
+ (NAAPIModel *)mineOrderInfoConfig;
/** 用户贷款记录接口 */
+ (NAAPIModel *)mineLoanListConfig;
/** 用户地址接口 */
+ (NAAPIModel *)userAddressConfig;
/** 更新地址接口 */
+ (NAAPIModel *)updateAddressConfigWithAddressModel:(NAAddressModel *)addressModel;
/** 会员礼品接口 */
+ (NAAPIModel *)vipPresentConfig;
/** 领取礼品接口 */
+ (NAAPIModel *)receivePresentConfig;
/** 礼品中心背景图接口 */
+ (NAAPIModel *)presentCenterBgConfig;
/** 分享成功接口 */
+ (NAAPIModel *)shareSuccessConfig;
/** 用户认证状态接口 */
+ (NAAPIModel *)authenticationStatusConfig;
/** 保存个人信息接口 */
+ (NAAPIModel *)updateUserInfoConfigWithModel:(NAUserInfoModel *)model;
/** 验证旧手机号接口 */
+ (NAAPIModel *)checkOldPhoneConfigWithSmsCode:(NSString *)smsCode;
/**
 设置新手机号接口

 @param phone 手机号
 @param smsCode 验证码
 @return NAAPIModel
 */
+ (NAAPIModel *)setNewPhoneConfigWithPhone:(NSString *)phone smsCode:(NSString *)smsCode;
/** 退出登录接口 */
+ (NAAPIModel *)logoutConfig;
/** 修改密码接口 */
+ (NAAPIModel *)changePasswordConfigWithPwd:(NSString *)password oldpwd:(NSString *)oldPassword;
/** 银行卡管理接口 */
+ (NAAPIModel *)bankCardsConfig;
/** 删除银行卡接口 */
+ (NAAPIModel *)deleteBankCardConfigWithCardId:(NSString *)cardId;
/** 添加银行卡接口 */
+ (NAAPIModel *)addBankCardConfigWithModel:(NABankCardModel *)model;
/** 验证绑定银行卡接口 */
+ (NAAPIModel *)validateBankCardConfigWithSmsCode:(NSString *)smsCode phone:(NSString *)phoneNumber cardNumber:(NSString *)cardNumber;
/** 身份认证接口 */
+ (NAAPIModel *)idCardAuthenticationConfig;
/** 脸部识别接口 */
+ (NAAPIModel *)faceIdentityConfig;
/** 用户认证完成接口 */
+ (NAAPIModel *)authenticationSaveConfigWithStep:(NSString *)step token:(NSString *)token;


/**
 苹果内购VIP会员后 后台验证接口

 @param receipt 内购的收据信息
 @param isSandBox 是否是测试
 @param imageId VIP会员页的imageId
 @return 内购会员后验证接口的NAAPIModel
 */
+ (NAAPIModel *)buyVipVerifyConfigWithReceipt:(NSString *)receipt isSandBox:(BOOL)isSandBox imageId:(NSString *)imageId;

#pragma mark - <--------------------所有其他的API接口------------------->
/** 身份证识别接口 */
+ (NAAPIModel *)idCardRecognitionConfigWithPicDataStr:(NSString *)picDataStr picType:(NSString *)picType;
/** 淘宝认证获取url接口 */
+ (NAAPIModel *)tbAuthenticationUrlConfig;
/** 京东认证获取url接口 */
+ (NAAPIModel *)jdAuthenticationUrlConfig;
/** 运营商认证获取url接口 */
+ (NAAPIModel *)serviceAuthenticationUrlConfig;
/** 发帖接口 */
+ (NAAPIModel *)postArticleConfigWithTitle:(NSString *)title body:(NSString *)body;
/**
 评论、回复接口
 
 @param body 内容
 @param commentID 评论id
 @return NAAPIModel
 */
+ (NAAPIModel *)commentConfigWithBody:(NSString *)body commentID:(NSString *)commentID;

/** 获取号码归属地接口 */
+ (NAAPIModel *)phoneAddressConfigWithPhoneNumber:(NSString *)phoneNumber;

#pragma mark - <---------------------所有的H5--------------------->
/** 确认订单页 */
+ (NSString *)confirmOrderH5UrlWithModel:(NAConfirmOrderModel *)orderModel;
/** 使用支付宝支付的美信会员页 */
+ (NSString *)vipH5UrlWithIsFromGiftCenter:(BOOL)isFromGiftCenter;
/* 使用apple内购的美信会员页 */
+ (NSString *)vipiOSH5UrlWithIsFromGiftCenter:(BOOL)isFromGiftCenter;
/* 信用体检页 */
+ (NSString *)creditReportH5Url;
/* 常见问题页 */
+ (NSString *)commonQuestionsH5Url;
/** 美信说-攻略 */
+ (NSString *)EssenceH5Url;
/** 美信说-社区 */
+ (NSString *)communityH5Url;
/** 我要赚钱页 */
+ (NSString *)makeMoneyH5Url;
/** 分享出去的商品详情页 */
+ (NSString *)sharedGoodsDetailH5UrlWithGoodsID:(NSString *)goodsID;

@end
