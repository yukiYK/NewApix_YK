//
//  NATabbarController.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/26.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NATabbarController.h"
#import "NAMainPageController.h"
#import "NAMeixinSayController.h"
#import "NAMineController.h"
#import "NALoginController.h"
#import "NANavigationController.h"

@interface NATabbarController () <UITabBarControllerDelegate>

@property (nonatomic, copy) NSString *token;

@end

@implementation NATabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.token = [NACommon getToken];
    self.delegate = self;
    
    [self addChildViewControllers];
}

- (void)addChildViewControllers {
    
    NAMainPageController *mainPageVC = [[NAMainPageController alloc] initWithNibName:@"NAMainPageController" bundle:nil];
    NAMeixinSayController *meixinSayVC = [[NAMeixinSayController alloc] init];
    NAMineController *mineVC = [[NAMineController alloc] init];
    
    NSArray<NABaseViewController*> *childVCArray = @[mainPageVC, meixinSayVC, mineVC];
//    if (!self.token) {
//        childVCArray = @[mainPageVC, meixinSayVC, loginVC];
//    }
    NSArray *nameArray = @[@"发现精选", @"美信说", @"会员中心"];
    NSArray *imageNameArray = @[@"tabbar_mainpage", @"tabbar_say", @"tabbar_mine"];
    for (int i=0; i<childVCArray.count; i++) {
        NABaseViewController *vc = childVCArray[i];
        NSString *name = nameArray[i];
        NSString *imageName = imageNameArray[i];
        [self addChildViewController:vc title:name imageName:imageName];
    }
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title imageName:(NSString *)imageName {
    
    childController.tabBarItem.image = [kGetImage(imageName) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [kGetImage(([NSString stringWithFormat:@"%@_selected",imageName])) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.title = title;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = kColorLightBlue;
    [childController.tabBarItem setTitleTextAttributes:dic forState:UIControlStateSelected];
    NANavigationController *naviC = [[NANavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:naviC];
}

// 警告框vc
- (void)alertViewClick {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"啊哦~金卡会员才能使用此权限呢~" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:[UIAlertAction actionWithTitle:@"立即开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *token = [NACommon getToken];
        NSLog(@"%@", token);
//        CommonWebViewController *meixinMethordVC = [[CommonWebViewController alloc]init];
//        meixinMethordVC.nvgTitle = @"美信会员";
//        meixinMethordVC.nvgUrl = [NSString stringWithFormat:@"%@/webapp/strategy/vipBuy?token=%@&device=app&type=1&source=newindex",H5HOST,token];
//        UINavigationController *vc = self.selectedViewController;
//        [vc pushViewController:meixinMethordVC animated:YES];
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - <UITabBarControllerDelegate>
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (![NACommon getToken] && viewController == self.viewControllers[2]) {
        UINavigationController *vc = self.selectedViewController;
        NALoginController *loginVC = [NAViewControllerCenter loginController];
        [vc pushViewController:loginVC animated:YES];
        return NO;
    }
    else if (![NACommon isRealVersion]) {
        NSLog(@"审核版");
        return YES;
    }
    else if (viewController == self.viewControllers[1] && [NACommon sharedCommon].userStatus != NAUserStatusVIP) {
        
        if (![NACommon getToken]) {
            
            UINavigationController *vc = self.selectedViewController;
            NALoginController *loginVC = [NAViewControllerCenter loginController];
            [vc pushViewController:loginVC animated:YES];
        }
        else {
            [self alertViewClick];
        }
        return NO;
    }
    return YES;
}


@end
