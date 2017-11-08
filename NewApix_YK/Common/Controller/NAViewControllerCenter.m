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
#import "NAIDAuthenticationController.h"
#import "NAIDUserFaceController.h"
#import "NAIDFaceCameraController.h"
#import "NALoanRecordController.h"
#import "NAWalletController.h"
#import "NAEncashmentController.h"
#import "NAArticleDetailController.h"
#import "NAMakeMoneyController.h"

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

/** 我要赚钱页 */
+ (UIViewController *)makeMoneyController {
    return [[NAMakeMoneyController alloc] init];
}

/**
 文章详情页
 
 @param articleUrl 文章url
 @param articleTitle 文章标题
 @return NAArticleDetailController
 */
+ (UIViewController *)articleDetailControllerWithUrl:(NSString *)articleUrl title:(NSString *)articleTitle {
    NAArticleDetailController *articleVC = [[NAArticleDetailController alloc] init];
    articleVC.articleUrl = articleUrl;
    articleVC.articleTitle = articleTitle;
    return articleVC;
}

/**
 编辑页 - 发帖、评论、回复评论

 @param editorType 编辑类型
 @param floor 回复楼层 回复类型专属
 @param nick 回复别人的昵称 回复类型专属
 @param commentID 评论id
 @return NAEditorController
 */
+ (UIViewController *)editorControllerWithType:(NAEditorType)editorType floor:(NSString *)floor nick:(NSString *)nick commentID:(NSString *)commentID {
    NAEditorController *editorVC = [[NAEditorController alloc] init];
    editorVC.editorType = editorType;
    editorVC.floorStr = floor;
    editorVC.nickName = nick;
    editorVC.commentIDStr = commentID;
    return editorVC;
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
+ (UIViewController *)presentCenterController {
    NAPresentCenterController *presentCenterC = [[NAPresentCenterController alloc] initWithNibName:@"NAPresentCenterController" bundle:nil];
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
 贷款记录页

 @param loanArray 贷款记录数据array
 @return NALoanRecordController
 */
+ (UIViewController *)loanRecordControllerWithArray:(NSArray *)loanArray {
    NALoanRecordController *loanRecordVC = [[NALoanRecordController alloc] init];
    loanRecordVC.loanArray = loanArray;
    return loanRecordVC;
}

/**
 钱包页
 
 @param walletModel 钱包数据model
 @return NAWalletController
 */
+ (UIViewController *)walletControllerWithModel:(NAWalletModel *)walletModel {
    NAWalletController *walletVC = [[NAWalletController alloc] initWithNibName:@"NAWalletController" bundle:nil];
    walletVC.walletModel = walletModel;
    return walletVC;
}

/**
 钱包提现页

 @param allMoney 钱包总额
 @return NAEncashmentController
 */
+ (UIViewController *)encashmentControllerWithAllMoney:(NSString *)allMoney {
    NAEncashmentController *encashmentVC = [[NAEncashmentController alloc] initWithNibName:@"NAEncashmentController" bundle:nil];
    encashmentVC.allMoney = allMoney;
    return encashmentVC;
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
 @return NASettingsController
 */
+ (UIViewController *)settingsControllerWithModel:(NAUserInfoModel *)model {
    NASettingsController *settingsVC = [[NASettingsController alloc] init];
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

/**
 身份认证页
 
 @return NAIDAuthenticationController
 */
+ (UIViewController *)idAuthenticationController {
    return [[NAIDAuthenticationController alloc] initWithNibName:@"NAIDAuthenticationController" bundle:nil];
}

/**
 脸部识别页
 
 @return NAIDUserFaceController
 */
+ (UIViewController *)idUserFaceController {
    return [[NAIDUserFaceController alloc] initWithNibName:@"NAIDUserFaceController" bundle:nil];
}



/**
 脸部识别相机页
 
 @param endBlock 拍照完成block
 @return NAIDFaceCameraController
 */
+ (UIViewController *)idFaceCameraControllerWithBlock:(CameraDidEndBlock)endBlock {
    NAIDFaceCameraController *cameraVC = [[NAIDFaceCameraController alloc] initWithNibName:@"NAIDFaceCameraController" bundle:nil];
    cameraVC.endBlock = endBlock;
    return cameraVC;
}

/**
 京东，淘宝，运营商认证页

 @param type NAAuthenticationType
 @return NAAuthenticationWebController
 */
+ (UIViewController *)authenticationWebController:(NAAuthenticationType)type {
    NAAuthenticationWebController *vc = [[NAAuthenticationWebController alloc] init];
    vc.authenticationType = type;
    return vc;
}


// 第三方贷款web页 等等
+ (UIViewController *)commonWebControllerWithCardModel:(NAMainCardModel *)cardModel isShowShareBtn:(BOOL)isShowShareBtn {
    NACommonWebController *commonWebVC = [[NACommonWebController alloc] init];
    if (cardModel) commonWebVC.cardModel = cardModel;
    commonWebVC.isShowShareBtn = isShowShareBtn;
    return commonWebVC;
}



@end
