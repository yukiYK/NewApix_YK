//
//  NAMeixinSayController.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAMeixinSayController.h"
#import "NAEssenceCell.h"
#import "NACommunityCell.h"

NSString * const kEssenceCellName = @"NAEssenceCell";
NSString * const kEssenceCellID = @"essenceCell";
NSString * const kCommunityCellName = @"NACommunityCell";
NSString * const kCommunityCellID = @"communityCell";

@interface NAMeixinSayController () <UIWebViewDelegate, UIScrollViewDelegate>

/** 头部两个button */
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIWebView *essenceWebView;
@property (nonatomic, strong) UIWebView *communityWebView;

@end

@implementation NAMeixinSayController
#pragma mark - <Lazy Load>

#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.headView removeFromSuperview];
}

- (void)setupNavigation {
    
    [self hideBackBtn];
    if (self.headView) {
        [self.navigationController.navigationBar addSubview:self.headView];
        return;
    }
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarH)];
    headView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:headView];
    self.headView = headView;
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth/2 - 60)/2, 0, 60, kNavBarH)];
    [leftBtn setTitle:@"精选" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorFromString:@"89abec"] forState:UIControlStateSelected];
    leftBtn.selected = YES;
    [leftBtn addTarget:self action:@selector(onLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:leftBtn];
    self.leftBtn = leftBtn;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2 + (kScreenWidth/2 - 60)/2, 0, 60, kNavBarH)];
    [rightBtn setTitle:@"社区" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorFromString:@"89abec"] forState:UIControlStateSelected];
    rightBtn.selected = NO;
    [rightBtn addTarget:self action:@selector(onRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightBtn];
    self.rightBtn = rightBtn;
}

- (void)setupSubviews {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kStatusBarH + kNavBarH, kScreenWidth, kScreenHeight - kStatusBarH - kNavBarH - kTabBarH)];
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(kScreenWidth * 2, scrollView.frame.size.height);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIWebView *essenceWebView = [[UIWebView alloc] initWithFrame:self.scrollView.bounds];
    essenceWebView.backgroundColor = [UIColor whiteColor];
    essenceWebView.delegate = self;
    NSURL *essenceUrl = [NSURL URLWithString:[NAURLCenter EssenceH5Url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:essenceUrl];
    [essenceWebView loadRequest:[NSURLProtocol canonicalRequestForRequest:request]];
    [scrollView addSubview:essenceWebView];
    self.essenceWebView = essenceWebView;
    
    UIWebView *communityWebView = [[UIWebView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, scrollView.bounds.size.height)];
    communityWebView.backgroundColor = [UIColor whiteColor];
    communityWebView.delegate = self;
    NSURL *communityUrl = [NSURL URLWithString:[NAURLCenter communityH5Url]];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:communityUrl];
    [communityWebView loadRequest:request2];
    [scrollView addSubview:communityWebView];
    self.communityWebView = communityWebView;
}

- (NSDictionary *)getObjectWithUrlString:(NSString *)urlString RangeString:(NSString *)rangeString {
    NSString *string = urlString.stringByRemovingPercentEncoding;
    string = [string substringFromIndex:[string rangeOfString:rangeString].location + rangeString.length];
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
}


#pragma mark - <Event>
- (void)onLeftBtnClicked:(UIButton *)sender {
    if (sender.selected) return;
    sender.selected = YES;
    self.rightBtn.selected = NO;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)onRightBtnClicked:(UIButton *)sender {
    if (sender.selected) return;
    sender.selected = YES;
    self.leftBtn.selected = NO;
    
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = request.URL.absoluteString;
    NSLog(@"urlStr = %@", urlStr);
    if ([urlStr hasPrefix:@"communityad"]) {
        
        NSDictionary *object = [self getObjectWithUrlString:urlStr RangeString:@"communityad:"];
        NSLog(@"%@",object);
        if([object[@"data"] rangeOfString:@"recommendedL"].location != NSNotFound) {
            //跳到推荐贷款
            
        } else {
            // 文章
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter articleDetailControllerWithUrl:object[@"data"] title:object[@"title"]]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:NO];
        }
        
        return NO;
    } else if ([urlStr hasPrefix:@"community"]) {
        NSDictionary *object = [self getObjectWithUrlString:urlStr RangeString:@"community:"];
        
        [NAViewControllerCenter transformViewController:self
                                       toViewController:[NAViewControllerCenter articleDetailControllerWithUrl:object[@"url"] title:@"美信说"]
                                          tranformStyle:NATransformStylePush
                                              needLogin:NO];
        
        
        return NO;
    } else if ([urlStr hasPrefix:@"finishrepay"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    } else if ([urlStr hasPrefix:@"forum"]) {  //点击社区中的帖子阅读
        NSDictionary *object = [self getObjectWithUrlString:urlStr RangeString:@"forum:"];
        NSLog(@"!!!!%@",object);
        if (([NAUserTool getUserStatus] == NAUserStatusVIPForever || [NAUserTool getUserStatus] == NAUserStatusVIP) || [object[@"grant"] isEqualToString:@"true"]) {
            // 跳转文章详情
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter articleDetailControllerWithUrl:object[@"data"] title:@"详情"]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"围观帖子请出示会员卡哦"];
        }
        return NO;
    } else if ([urlStr hasPrefix:@"post"]) {  //点击了社区中的发帖
        if ([NAUserTool getUserStatus] == NAUserStatusVIPForever || [NAUserTool getUserStatus] == NAUserStatusVIP) {
            // 跳转发帖
            UIViewController *toVC = [NAViewControllerCenter editorControllerWithType:NAEditorTypePost floor:@"" nick:@"" commentID:@""];
            [NAViewControllerCenter transformViewController:self toViewController:toVC tranformStyle:NATransformStylePush needLogin:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"发言请出示会员卡哦"];
        }
        return NO;
    } else if ([urlStr hasPrefix:@"read"]) {  //点击了攻略中的文章
        //解析数据
        NSDictionary *object = [self getObjectWithUrlString:urlStr RangeString:@"read:"];
        NSString *vipArticle = [NSString stringWithFormat:@"%@",object[@"vipartivle"]];
        NSLog(@"%@",vipArticle);
        
        if (([NAUserTool getUserStatus] == NAUserStatusVIPForever || [NAUserTool getUserStatus] == NAUserStatusVIP) && ([object[@"vipuser"] isEqualToString:@"0"] || [vipArticle isEqualToString:@"1"])) {
            // 跳转文章详情
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter articleDetailControllerWithUrl:object[@"url"] title:object[@"title"]]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"查看独家攻略需要您出示会员卡哦"];
        }
        return NO;
    }
    
    return YES;
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) return;
    
    if (scrollView.contentOffset.x == 0)
        [self.leftBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    else if (scrollView.contentOffset.x == kScreenWidth)
        [self.rightBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
