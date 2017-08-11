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

+ (UIViewController *)loginController {
    NALoginController *loginVC = [[NALoginController alloc] init];
    return loginVC;
}

@end
