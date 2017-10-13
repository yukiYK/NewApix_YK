//
//  NAAuthenticationModel.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/27.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAAuthenticationModel.h"

@implementation NAAuthenticationModel

+ (instancetype)sharedModel {
    static NAAuthenticationModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NAAuthenticationModel alloc] init];
    });
    return sharedInstance;
}

+ (NSArray *)getAllProperties {
    unsigned int outCount;
    
    objc_property_t *propertiesArray = class_copyPropertyList([self class], &outCount);
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i=0;i<outCount;i++) {
        objc_property_t property = propertiesArray[i];
        
        // 获取属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        [resultArr addObject:propertyName];
    }
    
    return resultArr;
}


///** 运营商 */
//- (void)setIsp:(NAAuthenticationState)isp {
//    [[NSUserDefaults standardUserDefaults] setInteger:isp forKey:kUserDefaultsAuthenticationService];
//}
//- (NAAuthenticationState)isp {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationService];
//}
//
///** 淘宝认证 */
//- (void)setTaobao:(NAAuthenticationState)taobao {
//    [[NSUserDefaults standardUserDefaults] setInteger:taobao forKey:kUserDefaultsAuthenticationTB];
//}
//- (NAAuthenticationState)taobao {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationTB];
//}
//
///** 京东认证 */
//- (void)setJingdong:(NAAuthenticationState)jingdong {
//    [[NSUserDefaults standardUserDefaults] setInteger:jingdong forKey:kUserDefaultsAuthenticationJD];
//}
//- (NAAuthenticationState)jingdong {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationJD];
//}
//
///** 通讯录 */
//- (void)setContact:(NAAuthenticationState)contact {
//    [[NSUserDefaults standardUserDefaults] setInteger:contact forKey:kUserDefaultsAuthenticationAddressBook];
//}
//- (NAAuthenticationState)contact {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationAddressBook];
//}
//
///** 身份认证 */
//- (void)setIdcard:(NAAuthenticationState)idcard {
//    [[NSUserDefaults standardUserDefaults] setInteger:idcard forKey:kUserDefaultsAuthenticationIDCard];
//}
//- (NAAuthenticationState)idcard {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationIDCard];
//}
//
///** 公积金 */
//- (void)setHousingfund:(NAAuthenticationState)housingfund {
//    [[NSUserDefaults standardUserDefaults] setInteger:housingfund forKey:kUserDefaultsAuthenticationHouse];
//}
//- (NAAuthenticationState)housingfund {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationHouse];
//}
//
///** 基本信息 */
//- (void)setInformation:(NAAuthenticationState)information {
//    [[NSUserDefaults standardUserDefaults] setInteger:information forKey:kUserDefaultsAuthenticationInfo];
//}
//- (NAAuthenticationState)information {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationInfo];
//}
//
///** 学信网 */
//- (void)setCredential:(NAAuthenticationState)credential {
//    [[NSUserDefaults standardUserDefaults] setInteger:credential forKey:kUserDefaultsAuthenticationSchool];
//}
//- (NAAuthenticationState)credential {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationSchool];
//}
//
///** 央行征信 */
//- (void)setReport:(NAAuthenticationState)report {
//    [[NSUserDefaults standardUserDefaults] setInteger:report forKey:kUserDefaultsAuthenticationCentralBank];
//}
//- (NAAuthenticationState)report {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationCentralBank];
//}
//
///** 芝麻信用 */
//- (void)setZhima:(NAAuthenticationState)zhima {
//    [[NSUserDefaults standardUserDefaults] setInteger:zhima forKey:kUserDefaultsAuthenticationSesameCredit];
//}
//- (NAAuthenticationState)zhima {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationSesameCredit];
//}
//
///** 芝麻认证 */
//- (void)setZhima_certifications:(NAAuthenticationState)zhima_certifications {
//    [[NSUserDefaults standardUserDefaults] setInteger:zhima_certifications forKey:kUserDefaultsAuthenticationSesame];
//}
//- (NAAuthenticationState)zhima_certifications {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationSesame];
//}
//
///** 借贷历史 */
//- (void)setLoan_history:(NAAuthenticationState)loan_history {
//    [[NSUserDefaults standardUserDefaults] setInteger:loan_history forKey:kUserDefaultsAuthenticationLoan];
//}
//- (NAAuthenticationState)loan_history {
//    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsAuthenticationLoan];
//}


@end