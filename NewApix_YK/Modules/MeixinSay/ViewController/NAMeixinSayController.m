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
    
    [self setupNavigation];
    [self setupSubviews];
}

- (void)setupNavigation {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarH)];
    headView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:headView];
    
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
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(kScreenWidth * 2, scrollView.frame.size.height);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIWebView *essenceWebView = [[UIWebView alloc] initWithFrame:self.scrollView.bounds];
    essenceWebView.delegate = self;
    NSURL *essenceUrl = [NSURL URLWithString:[NAURLCenter EssenceH5Url]];
    [essenceWebView loadRequest:[NSURLRequest requestWithURL:essenceUrl]];
    [scrollView addSubview:essenceWebView];
    self.essenceWebView = essenceWebView;
    
    UIWebView *communityWebView = [[UIWebView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, scrollView.bounds.size.height)];
    communityWebView.delegate = self;
    NSURL *communityUrl = [NSURL URLWithString:[NAURLCenter communityH5Url]];
    [communityWebView loadRequest:[NSURLRequest requestWithURL:communityUrl]];
    [scrollView addSubview:communityWebView];
    self.communityWebView = communityWebView;
}


#pragma mark - <Event>
- (void)onLeftBtnClicked:(UIButton *)sender {
    if (sender.selected) return;
    sender.selected = YES;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)onRightBtnClicked:(UIButton *)sender {
    if (sender.selected) return;
    sender.selected = YES;
    
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = request.URL.absoluteString;
    if ([urlStr isEqualToString:[NAURLCenter EssenceH5Url]] || [urlStr isEqualToString:[NAURLCenter communityH5Url]])
        return YES;
    
    // TODO
    
    return NO;
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
