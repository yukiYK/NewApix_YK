//
//  NALoanProtocolController.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/12/1.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NALoanProtocolController.h"

@interface NALoanProtocolController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation NALoanProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customTitleLabel.text = @"用户借款协议";
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    self.webView = webView;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    NSURL *url = [NSURL URLWithString:[NAURLCenter loanProtocolH5Url]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
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
