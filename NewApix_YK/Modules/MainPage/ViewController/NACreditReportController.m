//
//  NACreditReportController.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/6.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NACreditReportController.h"
#import "UIView+NAScreenshot.h"
#import "UIScrollView+NAScreenshot.h"
#import "UIImage+NAExtension.h"
#import <UMSocialCore/UMSocialCore.h>
#import "NAShareView.h"

@interface NACreditReportController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *urlStr;


@property (nonatomic, strong) NAShareView *shareView;

@property (nonatomic, strong) UMSocialMessageObject *msgObjc;

@end

@implementation NACreditReportController
#pragma mark - <Lazy Load>
- (UMSocialMessageObject *)msgObjc {
    if (!_msgObjc) {
        _msgObjc = [UMSocialMessageObject messageObject];
        _msgObjc.text = @"信用体检报告";
        
        UMShareImageObject *shareImageObjc = [[UMShareImageObject alloc] init];
        
        UIImage *image = [self getSaveImage];
        CGFloat height = kScreenWidth * image.size.height/image.size.width;
        shareImageObjc.shareImage = image;
        shareImageObjc.thumbImage = [self imageWithImage:image scaledToSize:CGSizeMake(kScreenWidth/4, height/4)];
        _msgObjc.shareObject = shareImageObjc;
    }
    return _msgObjc;
}

#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigation];
    [self setupWebView];
}

#pragma mark - <Private Method>
- (void)setupNavigation {
    self.navigationController.navigationBarHidden = NO;
    //    self.title = @"信用体检报告";
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 20, 30)];
    [left addTarget:self action:@selector(onBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [left setImage:kGetImage(kImageBackWhite) forState:UIControlStateNormal];
    [left setTitle:@"" forState:UIControlStateNormal];
    [left setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //修改方法
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [view addSubview:left];
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftBut;
    
    UIImage * image = [UIImage imageNamed:@"share_icon"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(onShareBtnClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)setupWebView {
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -kTopViewH, kScreenWidth, kScreenHeight + kTopViewH)];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    UIImageView *tipsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_moments"]];
    tipsImageView.frame = CGRectMake(kScreenWidth - 20 - 80, 54, 80, 22);
    [self.view addSubview:tipsImageView];
    
    self.urlStr = [NAURLCenter creditReportH5Url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

//- (void)clickQuan {
//    //    NSLog(@"我点击了朋友圈！！！！！！");
//    //分享纯文本消息到微信朋友圈，其他类型可以参考示例代码
//    OSMessage *msg=[[OSMessage alloc]init];
//    // 描述
//    msg.desc = [NSString stringWithFormat:@"信用体检报告"];
//    UIImage *image = [self getSaveImage];
//    CGFloat height = kScreenWidth * image.size.height/image.size.width;
//    msg.image = UIImageJPEGRepresentation(image, 1);
//    // 缩略图2进制数据
//    msg.thumbnail = [self imageWithImage:image scaledToSize:CGSizeMake(kScreenWidth/4, height/4)];
//    
//    [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
//        //    ULog(@"");
//        [self popAlartWithtitle:@"微信分享到朋友圈成功"];
//        [self shareToldHouTai];
//    } Fail:^(OSMessage *message, NSError *error) {
//        //   ULog(@"");
//        [self popAlartWithtitle:@"微信分享到朋友圈失败"];
//    }];
//}


- (UIImage *)getSaveImage {
    // 数据图片
    UIImage *dataImage = [self.webView.scrollView convertScrollViewToImage];
    
    UIImage *bottomImage = [UIImage imageNamed:@"qr_code"];
    CGFloat bottomHeight = kScreenWidth * bottomImage.size.height/bottomImage.size.width;
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, bottomHeight)];
    bottomImageView.backgroundColor = [UIColor whiteColor];
    bottomImageView.image = bottomImage;
    
    UIImage *qrImage = [bottomImageView convertViewToImage];
    
    UIImage *shareImage = [dataImage stitchBottomImage:qrImage];
    return shareImage;
}

// ------这种方法对图片既进行压缩，又进行裁剪
- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
    return imageData;
}

- (void)popAlartWithtitle:(NSString *)title {
    [self.view endEditing:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *isCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.view endEditing:YES];
    }];
    [alertController addAction:isCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - <Events>
- (void)onBackClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击分享
- (void)onShareBtnClicked:(UIButton *)button {
    if (!self.shareView) {
        WeakSelf
        self.shareView = [[NAShareView alloc] initWithActionBlock:^(UMSocialPlatformType sharePlatform) {
            [[UMSocialManager defaultManager] shareToPlatform:sharePlatform messageObject:weakSelf.msgObjc currentViewController:weakSelf completion:^(id result, NSError *error) {
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


#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [request URL].absoluteString;
    NSLog(@"%@", requestString);
    
    return YES;
}

@end
