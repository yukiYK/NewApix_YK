//
//  NAViewControllerCenter.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/10.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NALoginController.h"
#import "NARegisterController.h"
#import "NACommonWebController.h"

typedef NS_ENUM(NSInteger, NATransformType) {
    NATransformTypePush,
    NATransformTypePresent
};

/**
 工具类，用来获取几乎所有二级以上的viewController
 */
@interface NAViewControllerCenter : NSObject



/**
 viewController通用跳转方法 默认animation:YES

 @param fromVC fromViewController
 @param toVC toViewController
 @param type 跳转方式：push present
 @param needLogin 是否需要登录
 */
+ (void)transformViewController:(UIViewController *)fromVC
               toViewController:(UIViewController *)toVC
                   tranformType:(NATransformType)type
                      needLogin:(BOOL)needLogin;

/**
 登录页

 @return NALoginController
 */
+ (NALoginController *)loginController;

/**
 注册页
 
 @return NALoginController
 */
+ (NARegisterController *)registerController;

/**
 第三方贷款web页 等等

 @param cardModel 数据model，如果没有传nil
 @param isShowShareBtn 是否显示右上角分享按钮
 @return NACommonWebController
 */
+ (NACommonWebController *)commonWebControllerWithCardModel:(NAMainCardModel *)cardModel isShowShareBtn:(BOOL)isShowShareBtn;

@end
