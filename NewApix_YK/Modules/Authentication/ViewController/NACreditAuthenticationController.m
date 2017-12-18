//
//  NACreditAuthenticationController.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/12/18.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NACreditAuthenticationController.h"

@interface NACreditAuthenticationController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation NACreditAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customTitleLabel.text = @"查信用";
    [self setupWebView];
}

- (void)setupWebView {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    NSURL *url = [NSURL URLWithString:[NAURLCenter creditAuthenticationH5Url]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlStr = request.URL.absoluteString;
//    if ([urlStr hasPrefix:@""]) {
//
//        return YES;
//    }
    
    
    return YES;
}

@end
