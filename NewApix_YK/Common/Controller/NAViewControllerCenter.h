//
//  NAViewControllerCenter.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/10.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NAMainCardModel.h"


typedef NS_ENUM(NSInteger, NATransformStyle) {
    NATransformStylePush,
    NATransformStylePresent
};

/**
 工具类，用来获取几乎所有二级以上的viewController
 */
@interface NAViewControllerCenter : NSObject



/**
 viewController通用跳转方法 默认animation:YES

 @param fromVC fromViewController
 @param toVC toViewController
 @param transformStyle 跳转方式：push present
 @param needLogin 是否需要登录
 */
+ (void)transformViewController:(UIViewController *)fromVC
               toViewController:(UIViewController *)toVC
                   tranformStyle:(NATransformStyle)transformStyle
                      needLogin:(BOOL)needLogin;


#pragma mark - <各个页面>
/**
 登录页

 @return NALoginController
 */
+ (UIViewController *)loginController;

/**
 注册页
 
 @return NALoginController
 */
+ (UIViewController *)registerController;


/**
 忘记密码页

 @return NAForgetPasswordController
 */
+ (UIViewController *)forgetPasswordController;


/**
 手机登录页

 @return NAPhoneLoginController
 */
+ (UIViewController *)phoneLoginController;


/**
 美信会员页

 @return NAMeixinVIPController
 */
+ (UIViewController *)meixinVIPControllerWithIsFromGiftCenter:(BOOL)isFromGiftCenter;

/**
 礼品中心页

 @return NAPresentCenterController
 */
+ (UIViewController *)presentCenterControllerWithIsVipForever:(BOOL)isVipForever;

/**
 礼品领取成功页

 @return NAPresentSuccessController
 */
+ (UIViewController *)presentSuccessController;

/**
 用户地址页

 @return NAAddressController;
 */
+ (UIViewController *)addressController;

/**
 信用体检页

 @return NACreditReportController
 */
+ (UIViewController *)creditReportController;

/**
 个人设置页

 @param model 个人信息model
 @param isVipForever 是否是终身会员
 @return NASettingsController
 */
+ (UIViewController *)settingsControllerWithModel:(NAUserInfoModel *)model isVipForever:(BOOL)isVipForever;

/**
 修改手机号页

 @return NAChangePhoneController
 */
+ (UIViewController *)changePhoneController;

/** 设置新手机号页 */
+ (UIViewController *)newPhoneController;

/**
 修改密码页

 @return NAChangePasswordController
 */
+ (UIViewController *)changePasswordController;

/**
 关于我们页
 
 @return NAAboutUsController
 */
+ (UIViewController *)aboutUsController;

/**
 常见问题页
 
 @return NACommonQuestionsController
 */
+ (UIViewController *)commonQuestionsController;

/**
 银行卡管理页
 
 @return NABankCardsController
 */
+ (UIViewController *)bankCardsController;

/**
 第三方贷款web页 等等

 @param cardModel 数据model，如果没有传nil
 @param isShowShareBtn 是否显示右上角分享按钮
 @return NACommonWebController
 */
+ (UIViewController *)commonWebControllerWithCardModel:(NAMainCardModel *)cardModel isShowShareBtn:(BOOL)isShowShareBtn;

@end
