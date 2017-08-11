//
//  NAViewControllerCenter.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/10.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 工具类，用来获取几乎所有二级以上的viewController
 */
@interface NAViewControllerCenter : NSObject


+ (void)transformViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC needLogn:(BOOL)needLogin;

/**
 登录页

 @return NALoginViewControler
 */
+ (UIViewController *)loginController;

@end
