//
//  NACommon.h
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"

typedef NS_ENUM(NSInteger, NAUserStatus) {
    NAUserStatusNoLogin,     // 未登录
    NAUserStatusLoginError,  // 被别人顶掉
    NAUserStatusNormal,      // 普通用户
    NAUserStatusOverdue,     // 会员过期
    NAUserStatusVIP,         // 金卡会员用户
    NAUserStatusVIPForever   // 终身金卡会员
};

/**
 会员信息接口 完成回调

 @param userStatus 会员状态
 @param vipEndDate 会员到期日期
 @param vipSkin 会员卡图片的urlStr
 */
typedef void (^LoadCompleteBlock)(NAUserStatus userStatus, NSString *vipEndDate, NSString *vipSkin);


/**
 杂货类，可以获取各种神奇的东西 = =！
 */
@interface NACommon : NSObject

/** 初始化单例 */
+ (instancetype)sharedCommon;

#pragma mark - <UserStatus>
@property (nonatomic, assign) NAUserStatus userStatus;

/** 请求用户状态
 *  注意！！此方法会请求后台获取用户状态，
 *  所以并不会即时更新userStatus, 请在block回调中获取最新userStatus
 */
+ (void)loadUserStatusComplete:(LoadCompleteBlock)block;
/**
 获取会员剩余天数
 
 @param endDateStr yyyy-MM-dd
 @return 剩余天数
 */
+ (NSInteger)getVIPRemainingDays:(NSString *)endDateStr;

+ (void)openUrl:(NSString *)url;

#pragma mark - <审核版本>
/** 是否是实际用户看到的版本，否则为审核版 */
+ (BOOL)isRealVersion;
+ (void)setRealVersion:(BOOL)real;

#pragma mark - <Token>
/** 获取token */
+ (NSString *)getToken;
/** 设置token */
+ (void)setToken:(NSString *)token;
/** 获取uniqueid */
+ (NSString *)getUniqueId;
/** 设置uniqueid */
+ (void)setUniqueId:(NSString *)uniqueId;

#pragma mark - <上下拉刷新View>
/** 生成下拉刷新header */
- (MJRefreshGifHeader *)createMJRefreshGifHeaderWithTarget:(id)target action:(SEL)action;
/** 生成上拉加载footer */
- (MJRefreshAutoGifFooter *)createMJRefreshAutoGifFooterWithTarget:(id)target action:(SEL)action;

/** 生成无更多数据footer */
- (UIView *)createNoMoreDataFooterView;


@end
