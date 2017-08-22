//
//  NAViewControllerCenter.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/10.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAViewControllerCenter.h"
#import "NALoginController.h"


@implementation NAViewControllerCenter
// 跳转方法
+ (void)transformViewController:(UIViewController *)fromVC
               toViewController:(UIViewController *)toVC
                   tranformType:(NATransformType)type
                      needLogin:(BOOL)needLogin {
    
    if (needLogin && ![NACommon getToken]) {
        [fromVC.navigationController pushViewController:[self loginController] animated:YES];
    }
    else {
        switch (type) {
            case NATransformTypePush: {
                [fromVC.navigationController pushViewController:toVC animated:YES];
            }
                break;
            case NATransformTypePresent: {
                [fromVC presentViewController:toVC animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }
}

// 登录页
+ (NALoginController *)loginController {
    return [[NALoginController alloc] init];
}

// 注册页
+ (NARegisterController *)registerController {
    return [[NARegisterController alloc] init];
}


// 第三方贷款web页 等等
+ (NACommonWebController *)commonWebControllerWithCardModel:(NAMainCardModel *)cardModel isShowShareBtn:(BOOL)isShowShareBtn {
    
    NACommonWebController *commonWebVC = [[NACommonWebController alloc] init];
    if (cardModel) {
        commonWebVC.cardModel = cardModel;
    }
    commonWebVC.isShowShareBtn = isShowShareBtn;
    return commonWebVC;
}



@end
