//
//  NACommon.h
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh.h>

typedef NS_ENUM(NSInteger, NAUserStatus) {
    NAUserStatusNoLogin,     // 未登录
    NAUserStatusLoginError,  // 被别人顶掉
    NAUserStatusNormal,      // 普通用户
    NAUserStatusOverdue,     // 会员过期
    NAUserStatusVIP          // 金卡会员用户
};

typedef void(^LoadCompleteBlock) (NAUserStatus userStatus);

@interface NACommon : NSObject

@property (nonatomic, assign) NAUserStatus userStatus;
/** 请求用户状态
 *  注意！！此方法会请求后台获取用户状态，所以并不会即时更新userStatus
 */
+ (void)loadUserStatusComplete:(LoadCompleteBlock)block;


/** 初始化单例 */
+ (instancetype)sharedCommon;

/** 是否是实际用户看到的版本，否则为审核版 */
+ (BOOL)isRealVersion;
+ (void)setRealVersion:(BOOL)real;

/** 获取token */
+ (NSString *)getToken;
/** 设置token */
+ (void)setToken:(NSString *)token;

/** 生成下拉刷新header */
- (MJRefreshGifHeader *)createMJRefreshGifHeaderWithTarget:(id)target action:(SEL)action;
/** 生成上拉加载footer */
- (MJRefreshAutoGifFooter *)createMJRefreshAutoGifFooterWithTarget:(id)target action:(SEL)action;

/** 生成无更多数据footer */
- (UIView *)createNoMoreDataFooterView;


@end
