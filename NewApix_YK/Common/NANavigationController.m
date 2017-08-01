//
//  NANavigationController.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/1.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NANavigationController.h"

@interface NANavigationController ()

@end

@implementation NANavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)load{
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorFromString:@"333333"]
                                                           }];
    [[UINavigationBar appearance]setTintColor:[UIColor colorFromString:@"333333"]];
    //[[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0xF7/255.0 green:0x77/255.0 blue:0x6a/255.0 alpha:1]];
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // push的时候会隐藏底部的tab bar。
    if (self.childViewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        [self setNavigationBarHidden:NO animated:NO];
    }
    
    [super pushViewController:viewController animated:animated];
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
