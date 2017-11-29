//
//  NAAuthenticationModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/9/27.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 认证状态 */
typedef NS_ENUM(NSInteger, NAAuthenticationState) {
    NAAuthenticationStateNot = 0,     // 未认证
    NAAuthenticationStateAlready,     // 已认证
    NAAuthenticationStateOverdue,     // 已过期
    NAAuthenticationStateCanUpdate,   // 可更新
    NAAuthenticationStateAlreadyUpdate// 已更新
};

@interface NAAuthenticationModel : NSObject

/** 运营商 */
@property (nonatomic, assign) NAAuthenticationState isp;
/** 淘宝认证 */
@property (nonatomic, assign) NAAuthenticationState taobao;
/** 京东认证 */
@property (nonatomic, assign) NAAuthenticationState jingdong;
/** 通讯录 */
@property (nonatomic, assign) NAAuthenticationState contact;
/** 身份认证 */
@property (nonatomic, assign) NAAuthenticationState idcard;
/** 公积金 */
@property (nonatomic, assign) NAAuthenticationState housingfund;
/** 基本信息 */
@property (nonatomic, assign) NAAuthenticationState information;
/** 学信网 */
@property (nonatomic, assign) NAAuthenticationState credential;
/** 央行征信 */
@property (nonatomic, assign) NAAuthenticationState report;
/** 芝麻信用 */
@property (nonatomic, assign) NAAuthenticationState zhima;
/** 芝麻认证 */
@property (nonatomic, assign) NAAuthenticationState zhima_certifications;
/** 借贷历史 */
@property (nonatomic, assign) NAAuthenticationState loan_history;


/** 单例 */
+ (instancetype)sharedModel;

/** 获取此类的所有属性 */
//+ (NSArray *)getAllProperties;

/** 解析用户的认证状态 */
+ (void)analysisAuthentication:(NSDictionary *)returnValue;

/** 根据状态获取字符串 */
+ (NSString *)stringWithAuthenticationState:(NAAuthenticationState)state;

@end
