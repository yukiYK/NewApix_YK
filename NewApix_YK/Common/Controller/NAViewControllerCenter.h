//
//  NAViewControllerCenter.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/10.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NAMainCardModel.h"
#import "NAAuthenticationWebController.h"
#import "NAIDFaceCameraController.h"
#import "NAWalletModel.h"

typedef NS_ENUM(NSInteger, NATransformStyle) {
    NATransformStylePush,
    NATransformStylePresent
};

/**
 工具类，用来获取几乎所有的viewController
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
 文章详情页

 @param articleUrl 文章url
 @param articleTitle 文章标题
 @return NAArticleDetailController
 */
+ (UIViewController *)articleDetailControllerWithUrl:(NSString *)articleUrl title:(NSString *)articleTitle;


/**
 美信会员页

 @return NAMeixinVIPController
 */
+ (UIViewController *)meixinVIPControllerWithIsFromGiftCenter:(BOOL)isFromGiftCenter;

/**
 礼品中心页

 @return NAPresentCenterController
 */
+ (UIViewController *)presentCenterController;

/**
 礼品领取成功页

 @return NAPresentSuccessController
 */
+ (UIViewController *)presentSuccessController;

/**
 贷款记录页
 
 @param loanArray 贷款记录数据array
 @return NALoanRecordController
 */
+ (UIViewController *)loanRecordControllerWithArray:(NSArray *)loanArray;

/**
 钱包页

 @param walletModel 钱包数据model
 @return NAWalletController
 */
+ (UIViewController *)walletControllerWithModel:(NAWalletModel *)walletModel;

/**
 钱包提现页
 
 @param allMoney 钱包总额
 @return NAEncashmentController
 */
+ (UIViewController *)encashmentControllerWithAllMoney:(NSString *)allMoney;

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
 @return NASettingsController
 */
+ (UIViewController *)settingsControllerWithModel:(NAUserInfoModel *)model;

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
 添加银行卡页

 @return NAAddCardController
 */
+ (UIViewController *)addBankCardController;

/**
 身份认证页

 @return NAIDAuthenticationController
 */
+ (UIViewController *)idAuthenticationController;

/**
 脸部识别页

 @return NAIDUserFaceController
 */
+ (UIViewController *)idUserFaceController;

/**
 脸部识别相机页

 @param endBlock 拍照完成block
 @return NAIDFaceCameraController
 */
+ (UIViewController *)idFaceCameraControllerWithBlock:(CameraDidEndBlock)endBlock;

/**
 京东，淘宝，运营商认证页
 
 @param type NAAuthenticationType
 @return NAAuthenticationWebController
 */
+ (UIViewController *)authenticationWebController:(NAAuthenticationType)type;


/**
 第三方贷款web页 等等

 @param cardModel 数据model，如果没有传nil
 @param isShowShareBtn 是否显示右上角分享按钮
 @return NACommonWebController
 */
+ (UIViewController *)commonWebControllerWithCardModel:(NAMainCardModel *)cardModel isShowShareBtn:(BOOL)isShowShareBtn;

@end
