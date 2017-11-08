//
//  NACommonQuestionsController.m
//  NewApix_YK
//
//  Created by 陈帅 on 2017/10/5.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NACommonQuestionsController.h"
#import "Masonry.h"

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
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    
    NSString *urlStr = [NAURLCenter commonQuestionsH5Url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

@end
