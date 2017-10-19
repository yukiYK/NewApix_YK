//
//  NAAuthenticationWebController.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/19.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAAuthenticationWebController.h"
#import "NAAuthenticationModel.h"

@interface NAAuthenticationWebController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NAAPIModel *apiModel;

@end

@implementation NAAuthenticationWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    [self configureApiModel];
    [self requestForUrl];
}

- (void)configureApiModel {
    switch (self.authenticationType) {
        case NAAuthenticationTypeTD: {
            self.apiModel = [NAURLCenter tbAuthenticationUrlConfig];
        }
            break;
        case NAAuthenticationTypeJD: {
            self.apiModel = [NAURLCenter jdAuthenticationUrlConfig];
        }
            break;
        case NAAuthenticationTypeService: {
            self.apiModel = [NAURLCenter serviceAuthenticationUrlConfig];
        }
            break;
            
        default:
            break;
    }
}

- (void)loadUrlStr:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - <Net Request>
- (void)requestForUrl {
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:kTBApixKey forHTTPHeaderField:@"apix-key"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager netRequestWithApiModel:self.apiModel progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        NSString *code = [NSString stringWithFormat:@"%@", returnValue[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self loadUrlStr:[NSString stringWithFormat:@"%@", returnValue[@"url"]]];
        }
    } errorCodeBlock:nil failureBlock:nil];
}

// ⚠️不是我们自己的token, 是认证平台的token
- (void)requestForSave:(NSString *)token {
    NAAPIModel *model = [NAURLCenter authenticationSaveConfigWithStep:[NSString stringWithFormat:@"%ld", self.authenticationType] token:token];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [NAAuthenticationModel sharedModel].taobao = NAAuthenticationStateAlready;
        [SVProgressHUD showSuccessWithStatus:@"认证成功，每月可更新认证一次"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } errorCodeBlock:nil failureBlock:nil];
}


#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *string = [request URL].absoluteString;
    if ([string containsString:kAuthenticationSuccessUrl]) {
        
        NSString *str = string;
        NSRange range = [string rangeOfString:kAuthenticationSuccessUrl];
        str = [str substringFromIndex:range.location + range.length + 1];
        NSArray *arr = [str componentsSeparatedByString:@"="];
        if (arr.count > 1) {
            [self requestForSave:arr[1]];
        }
        return NO;
    } else if ([string containsString:kAuthenticationFailedUrl]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"认证失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

@end
