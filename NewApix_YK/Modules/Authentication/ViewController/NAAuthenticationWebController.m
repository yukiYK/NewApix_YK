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
@property (nonatomic, copy) NSString *licenseName;

@end

@implementation NAAuthenticationWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    if (self.authenticationType <= 5) {
        [self configureApiModel];
        [self requestForUrl];
    } else {
        NSString *urlStr = @"";
        switch (self.authenticationType) {
            case NAAuthenticationTypeSchool: {
                urlStr = [NAURLCenter schoolAuthenticationH5Url];
                self.customTitleLabel.text = @"学信网认证";
            }
                break;
            case NAAuthenticationTypeHouse: {
                urlStr = [NAURLCenter houseAuthenticationH5Url];
                self.customTitleLabel.text = @"公积金认证";
            }
                break;
            case NAAuthenticationTypeLoan: {
                urlStr = [NAURLCenter loanAuthenticationH5Url:self.loanStep];
                self.customTitleLabel.text = @"借贷历史认证";
            }
                break;
                
            default:
                break;
        }
        [self loadUrlStr:urlStr];
    }
}

- (void)configureApiModel {
    switch (self.authenticationType) {
        case NAAuthenticationTypeTB: {
            self.apiModel = [NAURLCenter tbAuthenticationUrlConfig];
            self.customTitleLabel.text = @"淘宝认证";
            self.licenseName = @"taobao";
        }
            break;
        case NAAuthenticationTypeJD: {
            self.apiModel = [NAURLCenter jdAuthenticationUrlConfig];
            self.customTitleLabel.text = @"京东认证";
            self.licenseName = @"jingdong";
        }
            break;
        case NAAuthenticationTypeService: {
            self.apiModel = [NAURLCenter serviceAuthenticationUrlConfig];
            self.customTitleLabel.text = @"运营商认证";
            self.licenseName = @"carrier";
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

- (NSDictionary *)getObjectWithUrlString:(NSString *)urlString rangeString:(NSString *)rangeString {
    NSString *string = urlString.stringByRemovingPercentEncoding;
    string = [string substringFromIndex:[string rangeOfString:rangeString].location + rangeString.length];
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
}

- (void)doVerify:(NSString *)url {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]]) {
        [NACommon openUrl:url];
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"是否下载并安装支付宝完成认证?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:cancelAction];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *appstoreUrl = @"itms-apps://itunes.apple.com/app/id333206289";
            [NACommon openUrl:appstoreUrl];
        }];
        [alertC addAction:goAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
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
- (void)requestForAuthenticationSave:(NSString *)token {
    NAAPIModel *model = [NAURLCenter authenticationSaveConfigWithStep:[NSString stringWithFormat:@"%ld", self.authenticationType] token:token];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [weakSelf requestForLicense];
    } errorCodeBlock:nil failureBlock:nil];
}

- (void)requestForLicense {
    NAAPIModel *model = [NAURLCenter authenticationLicenseConfigWith:self.licenseName];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
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
            [self requestForAuthenticationSave:arr[1]];
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
    } else if ([string hasPrefix:@"apix"]) {
        //解析数据
        NSDictionary *object = [self getObjectWithUrlString:string rangeString:@"apix:"];
        NSString *token = [NSString stringWithFormat:@"%@", object[@"token"]];
        [self requestForAuthenticationSave:token];
        return NO;
    } else if ([string hasPrefix:@"ds"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([string hasPrefix:@"lh"]) {
        NAAuthenticationWebController *toVC = (NAAuthenticationWebController *)[NAViewControllerCenter authenticationWebController:NAAuthenticationTypeLoan];
        toVC.loanStep = 2;
        [NAViewControllerCenter transformViewController:self toViewController:toVC tranformStyle:NATransformStylePush needLogin:NO];
    } else if ([string hasPrefix:@"tlh"]) {
        NAAuthenticationWebController *toVC = (NAAuthenticationWebController *)[NAViewControllerCenter authenticationWebController:NAAuthenticationTypeLoan];
        toVC.loanStep = 3;
        [NAViewControllerCenter transformViewController:self toViewController:toVC tranformStyle:NATransformStylePush needLogin:NO];
    } else if ([string hasPrefix:@"rc"]) {
        NSMutableDictionary *object = [NSMutableDictionary dictionaryWithDictionary:[self getObjectWithUrlString:string rangeString:@"rc:"]];
        self.licenseName = [NSString stringWithFormat:@"%@", object[@"name"]];
        return NO;
    } else if ([string containsString:@"alipays://platformapi"]) {
        [self doVerify:string];
        return NO;
    }
    return YES;
}

@end
