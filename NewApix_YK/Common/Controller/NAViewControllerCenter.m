//
//  NAViewControllerCenter.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/10.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAViewControllerCenter.h"
#import "NALoginController.h"
#import "NARegisterController.h"
#import "NACommonWebController.h"
#import "NAForgetPasswordController.h"
#import "NAPhoneLoginController.h"
#import "NAMeixinVIPController.h"
#import "NAPresentCenterController.h"
#import "NAPresentSuccessController.h"
#import "NAAddressController.h"
#import "NACreditReportController.h"
#import "NASettingsController.h"
#import "NAChangePhoneController.h"
#import "NAChangePasswordController.h"
#import "NANewPhoneController.h"
#import "NAAboutUsController.h"
#import "NACommonQuestionsController.h"
#import "NABankCardsController.h"
#import "NAAddCardController.h"

@implementation NAViewControllerCenter
// 跳转方法
+ (void)transformViewController:(UIViewController *)fromVC
               toViewController:(UIViewController *)toVC
                  tranformStyle:(NATransformStyle)transformStyle
                      needLogin:(BOOL)needLogin {
    
    if (needLogin && ![NACommon getToken]) {
        [fromVC.navigationController pushViewController:[self loginController] animated:YES];
    }
    else {
        switch (transformStyle) {
            case NATransformStylePush: {
                [fromVC.navigationController pushViewController:toVC animated:YES];
            }
                break;
            case NATransformStylePresent: {
                [fromVC presentViewController:toVC animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }
}

// 登录页
+ (UIViewController *)loginController {
    return [[NALoginController alloc] initWithNibName:@"NALoginController" bundle:nil];
}
// 注册页
+ (UIViewController *)registerController {
    return [[NARegisterController alloc] initWithNibName:@"NARegisterController" bundle:nil];
}
// 忘记密码页
+ (UIViewController *)forgetPasswordController {
    return [[NAForgetPasswordController alloc] initWithNibName:@"NAForgetPasswordController" bundle:nil];
}
// 手机登录页
+ (UIViewController *)phoneLoginController {
    return [[NAPhoneLoginController alloc] initWithNibName:@"NAPhoneLoginController" bundle:nil];
}

/**
 美信会员页
 
 @return NAMeixinVIPController
 */
+ (UIViewController *)meixinVIPControllerWithIsFromGiftCenter:(BOOL)isFromGiftCenter {
    NAMeixinVIPController *vipC = [[NAMeixinVIPController alloc] init];
    vipC.isFromGiftCenter = isFromGiftCenter;
    return vipC;
}

/**
 礼品中心页
 
 @return NAPresentCenterController
 */
+ (UIViewController *)presentCenterControllerWithIsVipForever:(BOOL)isVipForever {
    NAPresentCenterController *presentCenterC = [[NAPresentCenterController alloc] initWithNibName:@"NAPresentCenterController" bundle:nil];
    presentCenterC.isVipForever = isVipForever;
    return presentCenterC;
}

/**
 礼品领取成功页
 
 @return NAPresentSuccessController
 */
+ (UIViewController *)presentSuccessController {
    return [[NAPresentSuccessController alloc] initWithNibName:@"NAPresentSuccessController" bundle:nil];
}

/**
 用户地址页
 
 @return NAAddressController;
 */
+ (UIViewController *)addressController {
    return [[NAAddressController alloc] initWithNibName:@"NAAddressController" bundle:nil];
}

/**
 信用体检页
 
 @return NACreditReportController
 */
+ (UIViewController *)creditReportController {
    return [[NACreditReportController alloc] init];
}

/**
 个人设置页
 
 @param model 个人信息model
 @param isVipForever 是否是终身会员
 @return NASettingsController
 */
+ (UIViewController *)settingsControllerWithModel:(NAUserInfoModel *)model isVipForever:(BOOL)isVipForever {
    NASettingsController *settingsVC = [[NASettingsController alloc] init];
    settingsVC.isVipForever = isVipForever;
    if (model) settingsVC.userInfoModel = model;
    return settingsVC;
}

/**
 修改手机号页
 
 @return NAChangePhoneController
 */
+ (UIViewController *)changePhoneController {
    return [[NAChangePhoneController alloc] init];
}

/** 设置新手机号页 */
+ (UIViewController *)newPhoneController {
    return [[NANewPhoneController alloc] init];
}

/**
 修改密码页
 
 @return NAChangePasswordController
 */
+ (UIViewController *)changePasswordController {
    return [[NAChangePasswordController alloc] init];
}

/**
 关于我们页

 @return NAAboutUsController
 */
+ (UIViewController *)aboutUsController {
    return [[NAAboutUsController alloc] init];
}

/**
常见问题页

 @return NACommonQuestionsController
 */
+ (UIViewController *)commonQuestionsController {
    return [[NACommonQuestionsController alloc] init];
}

/**
 银行卡管理页

 @return NABankCardsController
 */
+ (UIViewController *)bankCardsController {
    return [[NABankCardsController alloc] init];
}

/**
 添加银行卡页
 
 @return NAAddCardController
 */
+ (UIViewController *)addBankCardController {
    return [[NAAddCardController alloc] initWithNibName:@"NAAddCardController" bundle:nil];
}

// 第三方贷款web页 等等
+ (UIViewController *)commonWebControllerWithCardModel:(NAMainCardModel *)cardModel isShowShareBtn:(BOOL)isShowShareBtn {
    
    NACommonWebController *commonWebVC = [[NACommonWebController alloc] init];
    if (cardModel) {
        commonWebVC.cardModel = cardModel;
    }
    commonWebVC.isShowShareBtn = isShowShareBtn;
    return commonWebVC;
}



@end
