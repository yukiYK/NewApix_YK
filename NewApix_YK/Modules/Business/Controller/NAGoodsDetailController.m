//
//  NAGoodsDetailController.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/15.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAGoodsDetailController.h"
#import "NABannerView.h"
#import "NAGoodsDetailCell.h"
#import <WebKit/WebKit.h>

static NSString * const kGoodsDetailCellName = @"NAGoodsDetailCell";
static NSString * const kGoodsDetailCellID = @"goodsDetailCell";

@interface NAGoodsDetailController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *vipBuyView;
@property (weak, nonatomic) IBOutlet UIView *buyView;
@property (weak, nonatomic) IBOutlet UILabel *vipPriceLabel;

@property (nonatomic, strong) NABannerView *bannerView;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSArray *bannerDataArray;

@end

@implementation NAGoodsDetailController
#pragma mark - <Lazy Load>
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 49)];
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kGoodsDetailCellName bundle:nil] forCellReuseIdentifier:kGoodsDetailCellID];
    self.tableView.tableHeaderView = [self tableHeaderView];
    self.tableView.tableFooterView = [self tableFooterView];
}

- (void)setupWebView {
    
}

- (UIView *)tableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth + 78)];
    
    NABannerView *bannerView = [[NABannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)
                                                         cardArray:self.bannerDataArray
                                                        clickBlock:^(NAMainCardModel *cardModel) {
                                                            NSLog(@"点击了banner");
                                                        }];
    [headerView addSubview:bannerView];
    self.bannerView = bannerView;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bannerView.frame), kScreenWidth, 78)];
    [headerView addSubview:bottomView];
    
    
    return headerView;
}

- (UIView *)tableFooterView {
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.backgroundColor = kColorGraySeperator;
    footerLabel.font = [UIFont systemFontOfSize:13];
    return footerLabel;
}

#pragma mark - <Net Request>
- (void)requestForGoodsDetail {
    
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.goodsModel.order_type == 3)
        return 4;
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NAGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailCellID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - <UIScrollViewDelegate>


@end
