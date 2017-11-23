//
//  NAMakeMoneyController.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/8.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAMakeMoneyController.h"
#import "NAShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "NAWalletModel.h"

@interface NAMakeMoneyController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NAShareView *shareView;

@property (nonatomic, strong) NAWalletModel *walletModel;

@end

@implementation NAMakeMoneyController
#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
}

#pragma mark - <Private Methods>
- (void)setupNavigation {
    self.customTitleLabel.text = @"我要赚钱";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
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
    
    NSURL *url = [NSURL URLWithString:[NAURLCenter makeMoneyH5Url]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)showShareView:(UMSocialMessageObject *)msgObjc {
    if (!self.shareView) {
        WeakSelf
        self.shareView = [[NAShareView alloc] initWithActionBlock:^(UMSocialPlatformType sharePlatform) {
            [[UMSocialManager defaultManager] shareToPlatform:sharePlatform messageObject:msgObjc currentViewController:weakSelf completion:^(id result, NSError *error) {
                if (error) return;
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                [weakSelf requestForShareSuccess];
                [weakSelf.shareView hide];
            }];
        }];
    }
    [self.shareView show];
}


#pragma mark - <Net Request>
//分享调用后台接口
- (void)requestForShareSuccess {
    if (![NACommon getToken]) return;
    
    NAAPIModel *model = [NAURLCenter shareSuccessConfig];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
    } errorCodeBlock:nil failureBlock:nil];
}

- (void)requestForWallet {
    NAAPIModel *model = [NAURLCenter walletConfig];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        weakSelf.walletModel = [NAWalletModel yy_modelWithJSON:returnValue];
        
    } errorCodeBlock:nil failureBlock:nil];
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = request.URL.absoluteString;
    if ([urlStr hasPrefix:@"mywallet"]) {
        [NAViewControllerCenter transformViewController:self
                                       toViewController:[NAViewControllerCenter walletControllerWithModel:self.walletModel]
                                          tranformStyle:NATransformStylePush
                                              needLogin:NO];
        return NO;
    } else if ([urlStr hasPrefix:@"makemoney"]) {
        NSRange range = [urlStr rangeOfString:@"url%22:%22"];
        //&my_type=\"之后的range
        range.location += range.length;
        range.length = [urlStr length] - range.location;
        NSRange range2 = [urlStr rangeOfString:@"%22" options:NSCaseInsensitiveSearch range:range];
        range.length = range2.location - range.location;
        NSString *subStr = [urlStr substringWithRange:range];
        NSLog(@"%@",subStr);
        NSString *shareUrl = subStr;
        
        range = [urlStr rangeOfString:@"title%22:%22"];
        //&my_type=\"之后的range
        range.location += range.length;
        range.length = [urlStr length] - range.location;
        range2 = [urlStr rangeOfString:@"%22" options:NSCaseInsensitiveSearch range:range];
        range.length = range2.location - range.location;
        subStr = [urlStr substringWithRange:range];
        NSLog(@"%@",subStr);
        NSString *shareTitle = [subStr stringByRemovingPercentEncoding];
        
        range = [urlStr rangeOfString:@"image%22:%22"];
        //&my_type=\"之后的range
        range.location += range.length;
        range.length = [urlStr length] - range.location;
        range2 = [urlStr rangeOfString:@"%22" options:NSCaseInsensitiveSearch range:range];
        range.length = range2.location - range.location;
        subStr = [urlStr substringWithRange:range];
        NSLog(@"%@",subStr);
        NSString *shareImg = subStr;
        
        range = [urlStr rangeOfString:@"summary%22:%22"];
        //&my_type=\"之后的range
        range.location += range.length;
        range.length = [urlStr length] - range.location;
        range2 = [urlStr rangeOfString:@"%22" options:NSCaseInsensitiveSearch range:range];
        range.length = range2.location - range.location;
        subStr = [urlStr substringWithRange:range];
        
        NSString *shareDescription = [subStr stringByRemovingPercentEncoding];
        
        UMSocialMessageObject *msgObjc = [UMSocialMessageObject messageObject];
        msgObjc.text = @"信用体检报告";
        
        UMShareWebpageObject *shareWebpageObjc = [[UMShareWebpageObject alloc] init];
        shareWebpageObjc.webpageUrl = shareUrl;
        shareWebpageObjc.title = shareTitle;
        shareWebpageObjc.descr = shareDescription;
        shareWebpageObjc.thumbImage = shareImg;
        msgObjc.shareObject = shareWebpageObjc;
        
        [self showShareView:msgObjc];
        return NO;
    }
    
    return YES;
}

@end
