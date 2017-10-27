//
//  NAMineHeaderView.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/18.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAMineOrderModel.h"
#import "NAUserInfoModel.h"

typedef void (^OrderBtnsActionBlock)(NSInteger btnTag);
typedef void (^VIPImageTapBlock)(void);
typedef void (^SettingsBlock)(void);

@interface NAMineHeaderView : UIView

/** 用户基本信息 昵称 头像等 */
@property (nonatomic, strong) NAUserInfoModel *userInfo;

/** 初始化方法 */
- (instancetype)initWithUserStatus:(NAUserStatus)userStatus settingsBlock:(SettingsBlock)settingsBlock orderBlock:(OrderBtnsActionBlock)orderBlock;


/**
 设置订单信息

 @param orderModel 订单model
 @param orderBlock 点击事件
 */
- (void)setOrderModel:(NAMineOrderModel *)orderModel orderBlock:(OrderBtnsActionBlock)orderBlock;


/**
 设置vip相关信息

 @param userStatus 会员状态
 @param endDate VIP截止日期  不是VIP的话传nil即可
 @param vipCardUrl 金卡会员图片地址
 @param vipImageBlock 会员卡片点击事件
 */
- (void)setUserStatus:(NAUserStatus)userStatus endDate:(NSString *)endDate vipCardUrl:(NSString *)vipCardUrl vipImageBlock:(VIPImageTapBlock)vipImageBlock;

@end
