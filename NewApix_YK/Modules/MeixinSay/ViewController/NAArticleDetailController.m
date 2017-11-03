//
//  NAArticleDetailController.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/2.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAArticleDetailController.h"

@interface NAArticleDetailController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation NAArticleDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customTitleLabel.text = self.articleTitle.length > 0 ? self.articleTitle : @"详情";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    NSURL *articleUrl = [NSURL URLWithString:self.articleUrl];
    [webView loadRequest:[NSURLRequest requestWithURL:articleUrl]];
    [self.view addSubview:webView];
    self.webView = webView;
}




@end
