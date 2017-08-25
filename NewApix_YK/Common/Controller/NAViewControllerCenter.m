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
