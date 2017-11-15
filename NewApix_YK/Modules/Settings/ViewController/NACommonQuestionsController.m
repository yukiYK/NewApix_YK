//
//  NACommonQuestionsController.m
//  NewApix_YK
//
//  Created by 陈帅 on 2017/10/5.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NACommonQuestionsController.h"

@interface NACommonQuestionsController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;


@end

@implementation NACommonQuestionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customTitleLabel.text = @"常见问题";
    [self setupWebview];
}

- (void)setupWebview {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    
    NSString *urlStr = [NAURLCenter commonQuestionsH5Url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

@end
