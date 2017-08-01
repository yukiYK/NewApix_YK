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

@interface NATabbarController ()

@property (nonatomic, copy) NSString *token;

@end

@implementation NATabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.token = [NACommon getToken];
    
    [self addChildViewControllers];
}

- (void)addChildViewControllers {
    
    NAMainPageController *mainPageVC = [[NAMainPageController alloc] initWithNibName:@"NAMainPageController" bundle:nil];
    NAMeixinSayController *meixinSayVC = [[NAMeixinSayController alloc] initWithNibName:@"NAMeixinSayController" bundle:nil];
    NAMineController *mineVC = [[NAMineController alloc] initWithNibName:@"NAMineController" bundle:nil];
    NALoginController *loginVC = [[NALoginController alloc] initWithNibName:@"NALoginController" bundle:nil];
    
    NSArray<NABaseViewController*> *childVCArray = @[mainPageVC, meixinSayVC, mineVC];
    if (!self.token) {
        childVCArray = @[mainPageVC, meixinSayVC, loginVC];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
