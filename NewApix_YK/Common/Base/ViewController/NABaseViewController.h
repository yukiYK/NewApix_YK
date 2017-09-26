//
//  NABaseViewController.h
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NANoNetworkView.h"

@interface NABaseViewController : UIViewController

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
/** 网络请求manager */
@property (nonatomic, strong) NAHTTPSessionManager *netManager;

@property (nonatomic, strong) NANoNetworkView *noNetworkView;

@property (nonatomic, weak) UILabel *customTitleLabel;

- (void)hideBackBtn;

- (void)removeReloadViewFromSuperView:(UIView *)superView;

- (void)showTabbar;
- (void)hideTabbar;

@end
