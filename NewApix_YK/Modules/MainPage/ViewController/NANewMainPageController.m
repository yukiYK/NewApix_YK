//
//  NANewMainPageController.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/25.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NANewMainPageController.h"

@interface NANewMainPageController () <UIWebViewDelegate>

@property (nonatomic, copy) NSString *urlStr;

@end

@implementation NANewMainPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/webapp/tourindex?source=newindex", SERVER_ADDRESS_H5]];
    NSLog(@"%@", url.absoluteString);
    self.urlStr = url.absoluteString;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

// 警告框vc
- (void)alertViewClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"啊哦~金卡会员才能使用此权限呢~" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:[UIAlertAction actionWithTitle:@"立即开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        CommonWebViewController *meixinMethordVC = [[CommonWebViewController alloc]init];
//        meixinMethordVC.nvgTitle = @"美信会员";
//        meixinMethordVC.nvgUrl = [NSString stringWithFormat:@"%@/webapp/strategy/vipBuy?token=%@&device=app&type=1&source=newindex",H5HOST,[APIXCommon getToken]];
//        [self.navigationController pushViewController:meixinMethordVC animated:YES];
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestUrl = request.URL.absoluteString;
    NSLog(@"%@", requestUrl);
    if ([requestUrl isEqualToString:self.urlStr]) {
        return YES;
    }
    else if ([requestUrl containsString:@"vipbuy"]) {
        if (![NACommon getToken]) {
            [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter loginController] tranformStyle:NATransformStylePush needLogin:NO];
        }
        else {
//            CommonWebViewController *meixinMethordVC = [[CommonWebViewController alloc]init];
//            meixinMethordVC.nvgTitle = @"美信会员";
//            meixinMethordVC.nvgUrl = [NSString stringWithFormat:@"%@/webapp/strategy/vipBuy?token=%@&device=app&type=1&source=newindex",H5HOST,[APIXCommon getToken]];
//            [self.navigationController pushViewController:meixinMethordVC animated:YES];
        }
    }
    else if ([requestUrl containsString:@"newindex"]) {
        if (![NACommon getToken]) {
            [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter loginController] tranformStyle:NATransformStylePush needLogin:NO];
        }
        else {
            [self alertViewClick];
        }
    }
    return NO;
}


@end
