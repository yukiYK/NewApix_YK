//
//  NACommon.h
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh.h>

@interface NACommon : NSObject

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
