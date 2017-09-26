//
//  NABaseViewController.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NABaseViewController.h"

@interface NABaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation NABaseViewController
#pragma mark - <Lazy Load>
- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        _activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        //        _activityView.color = [UIColor blackColor];
    }
    
    return _activityView;
}

- (NANoNetworkView *)noNetworkView {
    return [NANoNetworkView viewForNoNet];
}

- (NAHTTPSessionManager *)netManager {
    if (!_netManager) {
        _netManager = [NAHTTPSessionManager sharedManager];
    }
    return _netManager;
}

#pragma mark - <life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNavi];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (UIView *view in kKeyWindow.subviews) {
        if ([view isKindOfClass:[NANoNetworkView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - <Private Methods>
- (void)setupNavi {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:kGetImage(kImageBackBlack) style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:titleLabel];
    
    self.customTitleLabel = titleLabel;
}

- (void)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark <Public Methods>
- (void)hideBackBtn {
    [self.navigationItem setLeftBarButtonItem:nil];
}

- (void)removeReloadViewFromSuperView:(UIView *)superView {
    for (id view in superView.subviews) {
        if ([view isKindOfClass:[NANoNetworkView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)showTabbar {
    // tabbar
    [UIView animateWithDuration:0.2 animations:^{
        [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.height, [UIScreen mainScreen].bounds.size.width, kTabBarH)];
    }];
}

- (void)hideTabbar {
    
    [UIView animateWithDuration:.2 animations:^{
        [self.tabBarController.tabBar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, kTabBarH)];
    }];
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
