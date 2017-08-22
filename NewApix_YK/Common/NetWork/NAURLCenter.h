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


#pragma mark - <项目中的所有接口>
/** 审核开关接口 */
+ (NAAPIModel *)onOrOffConfigWithName:(NSString *)name origin:(NSString *)origin;

// --------------------------------首页----------------------------
/** 首页卡片接口 */
+ (NAAPIModel *)mainPageCardConfigWithVersion:(NSString *)version;

// ---------------------------------会员中心----------------------------
/** 用户基本信息接口 昵称 头像等 */
+ (NAAPIModel *)mineUserInfoConfigWithToken:(NSString *)token;

/** 用户vip信息接口 */
+ (NAAPIModel *)mineVipInfoConfigWithToken:(NSString *)token;

/** 用户订单信息接口 */
+ (NAAPIModel *)mineOrderInfoConfigWithToken:(NSString *)token;

/** 用户贷款记录接口 */
+ (NAAPIModel *)mineLoanListConfigWithToken:(NSString *)token;

@end
