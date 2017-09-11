//
//  NAMeixinVIPController.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/6.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAMeixinVIPController.h"
#import <StoreKit/StoreKit.h>
#import "Masonry.h"

@interface NAMeixinVIPController () <UIWebViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) UIWebView *webView;
//会员协议
@property (nonatomic, strong) UIView *scoreBackView;
@property (nonatomic, strong) UIImageView *myBlackView;

@property (nonatomic, copy) NSString *nvgUrl;

@property (nonatomic, strong) SKProductsRequest *productRequest;

@property (nonatomic, strong) UIActivityIndicatorView *activitiyView;

@property (nonatomic, copy) NSString *img_id;

@end

@implementation NAMeixinVIPController
- (UIActivityIndicatorView *)activitiyView {
    if (!_activitiyView) {
        _activitiyView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activitiyView.center = self.view.center;
        [self.view addSubview:_activitiyView];
    }
    return _activitiyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    [self setupWebView];
    
    // 开启内购检测
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


#pragma mark - <Private Method>
- (void)setupNavigationBar {
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"美信会员";
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(-20, 0, 35, 35)];
    [left addTarget:self action:@selector(onBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [left setImage:[UIImage imageNamed:@"backbtn"] forState:UIControlStateNormal];
    [left setTitle:@"" forState:UIControlStateNormal];
    [left setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //修改方法
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [view addSubview:left];
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftBut;
    
    UIImage * image = [UIImage imageNamed:@"vipXY"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)setupWebView {
    
    if ([NACommon isRealVersion]) {
        self.nvgUrl = [NAURLCenter vipiOSH5Url];
    }
    else {
        self.nvgUrl = [NAURLCenter vipH5Url];
    }
    self.nvgUrl = [self.nvgUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *url = [NSURL URLWithString:self.nvgUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    //加一个罩层 先设置其透明度为0  点击问号的时候再设置其透明度显示 点击时可以移除问号弹出的view
    UIImageView *blackView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    blackView.alpha = 0;
    blackView.backgroundColor = [UIColor blackColor];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:blackView];
    self.myBlackView = blackView;
    self.myBlackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBtn)];
    [self.myBlackView addGestureRecognizer:singleTap1];
}


#pragma mark - <Events>
- (void)onBackClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击协议按钮
- (void)rightBarItemClick:(UIBarButtonItem *)item {
    NSLog(@"点击了右上的按钮");
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [[UIView alloc]init];
    UIScrollView *descripView = [[UIScrollView alloc]init];
    self.scoreBackView = view;
    [window addSubview:self.scoreBackView];
    self.scoreBackView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*0.4, [UIScreen mainScreen].bounds.size.height*0.4, kScreenWidth*0.2,kScreenHeight*0.2 );
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(0, 8, self.scoreBackView.bounds.size.width, 30);
    view.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"美信生活付费会员卡用户协议";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.scoreBackView addSubview:titleLabel];
    descripView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*0.4, [UIScreen mainScreen].bounds.size.height*0.4, [UIScreen mainScreen].bounds.size.width*0.2,[UIScreen mainScreen].bounds.size.height*0.2 );
    
    UIImageView *scoreDescbV = [[UIImageView alloc] init];
    [descripView addSubview:scoreDescbV];
    UIImageView *scoreDescbV2 = [[UIImageView alloc] init];
    [descripView addSubview:scoreDescbV2];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.myBlackView.alpha = 0.7;
        self.scoreBackView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*0.1, [UIScreen mainScreen].bounds.size.height*0.15, kScreenWidth*0.8,kScreenHeight*0.65 );
        descripView.frame = CGRectMake(view.bounds.size.width *0.1, CGRectGetMaxY(titleLabel.frame)+5, view.bounds.size.width *0.8,view.bounds.size.height-60 );
        titleLabel.frame = CGRectMake(0, 8, self.scoreBackView.bounds.size.width, 30);
        
    } completion:^(BOOL finished) {
        [scoreDescbV sd_setImageWithURL:[NSURL URLWithString:@"https://meixinlife.com/webapp/images/community/vip-agreement-1.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            CGFloat height = (image.size.height/image.size.width) * view.bounds.size.width * 0.8;
            scoreDescbV.frame = CGRectMake(0, 20, view.bounds.size.width *0.8, height);
            scoreDescbV2.frame = CGRectMake(0, CGRectGetMaxY(scoreDescbV.frame), scoreDescbV2.width, scoreDescbV2.height);
            scoreDescbV.image = image;
            descripView.contentSize = CGSizeMake(view.bounds.size.width *0.8,CGRectGetMaxY(scoreDescbV2.frame) + 20);
        }];
        
        
        [scoreDescbV2 sd_setImageWithURL:[NSURL URLWithString:@"https://meixinlife.com/webapp/images/community/vip-agreement-2.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            CGFloat height = (image.size.height/image.size.width) * view.bounds.size.width * 0.8;
            scoreDescbV2.frame = CGRectMake(scoreDescbV2.frame.origin.x, scoreDescbV2.frame.origin.y, view.bounds.size.width *0.8, height);
            scoreDescbV2.image = image;
            descripView.contentSize = CGSizeMake(view.bounds.size.width *0.8,CGRectGetMaxY(scoreDescbV2.frame) + 20);
            
        }];
        [self.scoreBackView addSubview:descripView];
        
    }];
}

//罩层点击事件
-(void)clickBtn {
    [UIView animateWithDuration:1 animations:^{
        self.myBlackView.alpha = 0;
        self.scoreBackView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            //            [self.myBlackView removeFromSuperview];
            [self.scoreBackView removeFromSuperview];
        }];
    }];
}

- (void)buyVipWithProductId:(NSString *)productId {
    
    if ([SKPaymentQueue canMakePayments]) {
        NSSet *nsSet = [NSSet setWithObjects:productId, nil];
        self.productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:nsSet];
        self.productRequest.delegate = self;
        [self.productRequest start];
    }
    else {
        NSLog(@"不允许内购付费");
    }
    [self.activitiyView startAnimating];
}

#pragma mark - <NetRequest>
- (void)requestForVerify:(NSString *)dataStr {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/vip/ios/add", SERVER_ADDRESS_API];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"receipt"] = dataStr;
    param[@"is_sandbox"] = @(SERVER_ONLINE?0:1);
    param[@"img_id"] = self.img_id;
    param[@"apix_token"] = [NACommon getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    [manager POST:urlStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dic = responseObject;
        NSString *code = [NSString stringWithFormat:@"%@", dic[@"code"]];
        if ([code isEqualToString:@"0"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"会员购买成功,快去享受主宰自己人生吧~" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
        }
        else if ([code isEqualToString:@"-1"]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"数据异常，请联系客服处理" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
        }
        else if ([code isEqualToString:@"-2"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"套餐异常，请联系客服处理" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络错误error=%@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"套餐异常，请联系客服处理" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
    }];
}


#pragma mark - <SKProductsRequestDelegate, SKPaymentTransactionObserver>
// 请求产品信息的结果
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *productArr = response.products;
    if ([productArr count] == 0) return;
    NSLog(@"productId = %@", response.invalidProductIdentifiers);
    SKProduct *product = nil;
    for (SKProduct *pro in productArr) {
        if ([pro.productIdentifier isEqualToString:kProductVipMonth]) {
            product = pro;
        }
    }
    if (product != nil) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

// 请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self.activitiyView stopAnimating];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"购买失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
}

- (void)requestDidFinish:(SKRequest *)request {
    
}

// 监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                [self paymentCompleteTransaction:tran];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                break;
            case SKPaymentTransactionStateFailed: {
                NSLog(@"交易失败");
                [self.activitiyView stopAnimating];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"购买失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)paymentCompleteTransaction:(SKPaymentTransaction *)transactions {
    
    [self.activitiyView stopAnimating];
    NSString *productId = transactions.payment.productIdentifier;
    if ([productId length] > 0) {
        NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
        //        NSLog(@"receiptData = %@",receiptData);
        //        NSString *dataStr = [[NSString alloc] initWithData:receiptData encoding:NSUTF8StringEncoding];
        //        NSLog(@"dataStr = %@", dataStr);
        //        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64 = [receiptData base64EncodedStringWithOptions:0];
        [self requestForVerify:base64];
    }
    else {
        NSLog(@"无订单");
    }
}

- (NSString *)URLDecodedString:(NSString *)str {
    
    [@"123" stringByRemovingPercentEncoding];
    //    CFURLCreateStringByReplacingPercentEscapes
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, (__bridge CFStringRef)str, CFSTR(""));
    
    return decodedString;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonStr {
    if (!jsonStr) return nil;
    
    NSString *string = [self URLDecodedString:jsonStr];
    
    string = [string substringFromIndex:7];
    NSLog(@"%@", string);
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    return dic;
}


#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlStr = request.URL.absoluteString;
    NSLog(@"%@", urlStr);
    
    if ([urlStr hasPrefix:@"iospay:"]) {
        NSDictionary *dic = [self dictionaryWithJsonString:urlStr];
        NSLog(@"%@", dic);
        NSString *img_id = [NSString stringWithFormat:@"%@", dic[@"img_id"]];
        NSString *ios_id = [NSString stringWithFormat:@"%@", dic[@"ios_id"]];
        self.img_id = img_id;
        
        [self buyVipWithProductId:ios_id];
        return NO;
    }
    else if ([urlStr hasPrefix:@"alipays://"] || [urlStr hasPrefix:@"alipay://"]) {
        
        // NOTE: 跳转支付宝App
        BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
        
        // NOTE: 如果跳转失败，则跳转itune下载支付宝App
        if (!bSucc) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未检测到支付宝客户端，请安装后重试。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"立即安装" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString* urlStr = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
                NSURL *downloadUrl = [NSURL URLWithString:urlStr];
                [[UIApplication sharedApplication]openURL:downloadUrl];
            }];
            [alert addAction:cancelAction];
            [alert addAction:goAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        return NO;
    }
    
    return YES;
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
