//
//  NALoanNoInterestController.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/11/27.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NALoanNoInterestController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "NAShareView.h"

@interface NALoanNoInterestController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NAShareView *shareView;

@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareImg;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDescription;

@end

@implementation NALoanNoInterestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
}

- (void)setupNavigation {
    if (self.isLoanReview) {
        self.customTitleLabel.text = @"贷款审核";
    } else self.customTitleLabel.text = @"无息贷款";
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
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    NSURL *url = [NSURL URLWithString:[NAURLCenter loanNoInterestH5Url]];
    if (self.isLoanReview)
        url = [NSURL URLWithString:[NAURLCenter loanReviewH5Url]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)showShareView {
    UMSocialMessageObject *msgObjc = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareWebpageObjc = [[UMShareWebpageObject alloc] init];
    shareWebpageObjc.webpageUrl = self.shareUrl;
    shareWebpageObjc.title = self.shareTitle;
    shareWebpageObjc.descr = self.shareDescription;
    shareWebpageObjc.thumbImage = self.shareImg;
    msgObjc.shareObject = shareWebpageObjc;
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

- (NSDictionary *)getObjectWithUrlString:(NSString *)urlString RangeString:(NSString *)rangeString {
    NSString *string = urlString.stringByRemovingPercentEncoding;
    string = [string substringFromIndex:[string rangeOfString:rangeString].location + rangeString.length];
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
}


#pragma mark - <Events>
- (void)onShareBtnClicked {
    
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

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *string = request.URL.absoluteString;
    NSLog(@"urlStr = %@", string);
    
    //点击了卡片非会员的无息贷款中未登录状态
    if ([string hasPrefix:@"nologin"]) {
        [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter loginController] tranformStyle:NATransformStylePush needLogin:NO];
        return NO;
    }
    
    // 信用体检
    if ([string hasSuffix:@"creditexam"] || [string containsString:@"creditReport"]) {
        [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter creditReportController] tranformStyle:NATransformStylePush needLogin:NO];
        return NO;
    }
    // 点击无息贷款下面的三个区域   智能推荐 帮你赚钱 帮你省钱
    if ([string hasPrefix:@"reviewfalied"]) {
        NSDictionary *object = [self getObjectWithUrlString:string RangeString:@"reviewfalied:"];
        NSLog(@"!!!!!@@%@",object);
        if ([object[@"modal"] isEqualToString:@"loan"]) {
        } else if ([object[@"modal"] isEqualToString:@"money"]) {
            //帮你赚钱
            [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter makeMoneyController] tranformStyle:NATransformStylePush needLogin:NO];
        } else if ([object[@"modal"] isEqualToString:@"shop"]) {
            //帮你省钱
            NSNotification *notification = [NSNotification notificationWithName:@"shopstore" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        return NO;
    }
    
    //点击了无息贷款中的推荐贷款
    if ([string hasPrefix:@"recommanloand"]) {
        return NO;
    }
    //点击了无息贷款中的我知道了  返回主页
    if ([string hasPrefix:@"goindex"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    if ([string hasPrefix:@"pinxy"]) {
        // TODO 跳转拼信用
        [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter authenticationController] tranformStyle:NATransformStylePush needLogin:NO];
        return NO;
    }
    if ([string hasPrefix:@"novip"]) {
        //无息贷款不是金卡会员 需要够买金卡会员
        [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter meixinVIPControllerWithIsFromGiftCenter:NO] tranformStyle:NATransformStylePush needLogin:YES];
        return NO;
    }
    //更改的标题
    if ([string hasPrefix:@"loanchecktiitle"]) {
        NSDictionary *object = [self getObjectWithUrlString:string RangeString:@"loanchecktiitle:"];
        NSLog(@"!!!!!@@%@",object);
        self.shareTitle = [NSString stringWithFormat:@"%@",object[@"sharetitle"]];
        self.title = [NSString stringWithFormat:@"%@",object[@"title"]];
        return NO;
    }
    if ([string hasPrefix:@"changetitle"]) {
        NSDictionary *object = [self getObjectWithUrlString:string RangeString:@"changetitle:"];
        NSLog(@"!!!!!@@%@",object);
        self.shareTitle = [NSString stringWithFormat:@"%@",object[@"sharetitle"]];
        self.customTitleLabel.text = [NSString stringWithFormat:@"%@",object[@"title"]];
        if([self.customTitleLabel.text isEqualToString:@"还款"]) {
            NSLog(@"不分享");
        } else {
            UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc]initWithImage:kGetImage(@"share_icon_black") style:UIBarButtonItemStyleDone target:self action:@selector(onShareBtnClicked)];
            self.navigationItem.rightBarButtonItem = rightBarItem;
            
            self.shareUrl = [NSString stringWithFormat:@"%@",object[@"url"]];
            //    self.shareTitle = [NSString stringWithFormat:@"%@",object[@"sharetitle"]];
            self.shareImg = [NSString stringWithFormat:@"%@",object[@"image"]];
            self.shareDescription = [NSString stringWithFormat:@"%@",object[@"summary"]];
        }
        
        return NO;
        
    }
    //借款历史
    if ([string hasPrefix:@"loanhistory"]) {
        [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter loanRecordControllerWithArray:nil] tranformStyle:NATransformStylePush needLogin:NO];
        return NO;
    }
    //再借一笔
    if ([string hasPrefix:@"loanagain"]) {
        NSLog(@"再借一笔");
        NSNotification *notification = [NSNotification notificationWithName:@"loanwuxi" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        return NO;
    }
    //点击了审核通过分享按钮
    if ([string hasPrefix:@"loansuccess"]) {
        NSDictionary *object = [self getObjectWithUrlString:string RangeString:@"loansuccess:"];
        NSLog(@"!!!!!@@%@",object);
        self.shareUrl = [NSString stringWithFormat:@"%@",object[@"url"]];
        //    self.shareTitle = [NSString stringWithFormat:@"%@",object[@"sharetitle"]];
        self.shareImg = [NSString stringWithFormat:@"%@",object[@"image"]];
        self.shareDescription = [NSString stringWithFormat:@"%@",object[@"summary"]];
        
        [self showShareView];
        return NO;
    }
    
    //无息贷款中的添加银行卡
    if ([string hasPrefix:@"addbankcard"]) {
        [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter addBankCardController] tranformStyle:NATransformStylePush needLogin:NO];
        return NO;
    }
    //信用报告里面足迹跳转
    if ([string hasPrefix:@"gotoch"]) {
//        CommonWebViewController *commonWebVc1 = [[CommonWebViewController alloc]init];
//        commonWebVc1.nvgUrl = [NSString stringWithFormat:@"%@/webapp/creditexamhistory?token=%@",H5HOST,self.token];
//        [self presentViewController:commonWebVc1 animated:YES completion:nil];
        return NO;
    }
    //跳转到拼信用
    if ([string hasPrefix:@"gotopin"]) {
        // TODO 跳转拼信用
        [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter authenticationController] tranformStyle:NATransformStylePush needLogin:NO];
        return NO;
    }
    
    return YES;
}

@end
