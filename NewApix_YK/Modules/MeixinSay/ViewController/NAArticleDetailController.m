//
//  NAArticleDetailController.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/2.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAArticleDetailController.h"
#import "NAShareView.h"
#import <UMSocialCore/UMSocialCore.h>

@interface NAArticleDetailController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NAShareView *shareView;

@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareImg;
@property (nonatomic, copy) NSString *shareDescription;

@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) UMSocialMessageObject *msgObjc;

@end

@implementation NAArticleDetailController
#pragma mark - <Lazy Load>
- (UMSocialMessageObject *)msgObjc {
    if (!_msgObjc) {
        _msgObjc = [UMSocialMessageObject messageObject];
        _msgObjc.text = @"信用体检报告";
        
        UMShareWebpageObject *shareWebpageObjc = [[UMShareWebpageObject alloc] init];
        
//        UIImage *image = [self getSaveImage];
//        CGFloat height = kScreenWidth * image.size.height/image.size.width;
//        shareImageObjc.shareImage = image;
//        shareImageObjc.thumbImage = [self imageWithImage:image scaledToSize:CGSizeMake(kScreenWidth/4, height/4)];
        _msgObjc.shareObject = shareWebpageObjc;
    }
    return _msgObjc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupWebview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
}

- (void)setupWebview {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    NSURL *articleUrl = [NSURL URLWithString:self.articleUrl];
    [webView loadRequest:[NSURLRequest requestWithURL:articleUrl]];
    [self.view addSubview:webView];
    self.webView = webView;
}

- (void)setupNavigation {
    self.customTitleLabel.text = self.articleTitle.length > 0 ? self.articleTitle : @"详情";
    
    if (self.articleType == NAArticleTypeCommunity) {
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithImage:kGetImage(@"share_icon_black") style:UIBarButtonItemStyleDone target:self action:@selector(onShareBtnClick)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
}

- (NSDictionary *)getObjectWithUrlString:(NSString *)urlString RangeString:(NSString *)rangeString {
    NSString *string = urlString.stringByRemovingPercentEncoding;
    string = [string substringFromIndex:[string rangeOfString:rangeString].location + rangeString.length];
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
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

#pragma mark - <Events>
- (void)onShareBtnClick {
    if (!self.shareView) {
        WeakSelf
        self.shareView = [[NAShareView alloc] initWithActionBlock:^(NSInteger index) {
            // @"微信", @"朋友圈", @"QQ", @"QQ空间"
            UMSocialPlatformType platform = UMSocialPlatformType_WechatTimeLine;
            switch (index) {
                case 0:
                    platform = UMSocialPlatformType_WechatSession;
                    break;
                case 1:
                    platform = UMSocialPlatformType_WechatTimeLine;
                    break;
                case 2:
                    platform = UMSocialPlatformType_QQ;
                    break;
                case 3:
                    platform = UMSocialPlatformType_Qzone;
                    break;
                    
                default:
                    break;
            }
            [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:weakSelf.msgObjc currentViewController:weakSelf completion:^(id result, NSError *error) {
                if (error) return;
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                [weakSelf requestForShareSuccess];
                [weakSelf.shareView hide];
            }];
        }];
    }
    [self.shareView show];
}


#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = request.URL.absoluteString;
    if ([urlStr hasPrefix:@"as"]) {
        NSDictionary *object = [self getObjectWithUrlString:urlStr RangeString:@"as:"];
        self.shareUrl = object[@"url"];
        self.shareTitle = object[@"title"];
        self.shareImg = object[@"image"];
        self.shareDescription = object[@"summary"];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.shareImg] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            self.shareImage = image;
        }];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithImage:kGetImage(@"share_icon_black") style:UIBarButtonItemStyleDone target:self action:@selector(onShareBtnClick)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
        
        return NO;
    } else if ([urlStr hasPrefix:@"cchongbao"]) {
        NSDictionary *object = [self getObjectWithUrlString:urlStr RangeString:@"cchongbao:"];
        // 跳转邀请好友得红包
        
        return NO;
    } else if ([urlStr hasPrefix:@"review"]) {
        NSDictionary *object = [self getObjectWithUrlString:urlStr RangeString:@"review:"];
        // 跳转回复页面
        
        return NO;
    }
    
    
    return YES;
}

@end
