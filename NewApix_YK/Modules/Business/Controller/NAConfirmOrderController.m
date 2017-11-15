//
//  NAConfirmOrderController.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/14.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAConfirmOrderController.h"

@interface NAConfirmOrderController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation NAConfirmOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customTitleLabel.text = @"确认订单";
    [self setupWebView];
}

- (void)setupWebView {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    NSString *encodedString = [[NAURLCenter confirmOrderH5UrlWithModel:self.orderModel] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodedString];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = request.URL.absoluteString;
    NSLog(@"urlStr = %@", urlStr);
    
    if ([urlStr hasPrefix:@"alipays://"] || [urlStr hasPrefix:@"alipay://"]) {
        if (![[UIApplication sharedApplication] openURL:request.URL]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未检测到支付宝客户端，请安装后重试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *downloadAction = [UIAlertAction actionWithTitle:@"立即安装" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *downloadStr = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
                NSURL *downloadUrl = [NSURL URLWithString:downloadStr];
                [[UIApplication sharedApplication] openURL:downloadUrl];
            }];
            [alert addAction:cancelAction];
            [alert addAction:downloadAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        return NO;
    }
        
    return YES;
}

@end
