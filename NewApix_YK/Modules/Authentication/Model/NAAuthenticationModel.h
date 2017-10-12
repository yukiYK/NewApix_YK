//
//  NAAuthenticationModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/9/27.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

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

+ (instancetype)sharedModel;

+ (NSArray *)getAllProperties;

@end
