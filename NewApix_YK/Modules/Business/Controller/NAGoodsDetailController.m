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
#import "NAGoodsInformationView.h"
#import "NAGoodsChildModel.h"
#import "NAAddressModel.h"
#import "NAShareView.h"
#import "NAGoodsFeatureView.h"
#import <UMSocialCore/UMSocialCore.h>

static NSString * const kGoodsDetailCellName = @"NAGoodsDetailCell";
static NSString * const kGoodsDetailCellID = @"goodsDetailCell";

@interface NAGoodsDetailController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *vipBuyView;
@property (weak, nonatomic) IBOutlet UIView *buyView;
@property (weak, nonatomic) IBOutlet UILabel *vipPriceLabel;
@property (nonatomic, strong) NABannerView *bannerView;
@property (nonatomic, strong) NAGoodsInformationView *informationView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NAShareView *shareView;
/** 弹出的选择规格view */
@property (nonatomic, strong) NAGoodsFeatureView *featureView;

@property (nonatomic, copy) NSString *goodsHtml;

/** 会员等级 */
@property (nonatomic, strong) NSArray *vipGradeArr;
@property (nonatomic, strong) NSArray *productTagsArr;
/** 子商品数组 内部NAGoodsChildModel */
@property (nonatomic, strong) NSArray *childrenArr;
/** 商品图片url数组 也就是banner */
@property (nonatomic, strong) NSArray *imgArr;
/** 当前选中的子商品 */
@property (nonatomic, strong) NAGoodsChildModel *childModel;
/** 地址信息 */
@property (nonatomic, strong) NAAddressModel *addressModel;


/** 是否选择了商品规格 */
@property (nonatomic, assign) BOOL isChoseChild;

@end

@implementation NAGoodsDetailController
#pragma mark - <Lazy Load>
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, self.view.height - 49 - kStatusBarH)];
        _webView.scrollView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupTableView];
    [self resetSubviews];
    [self requestForGoodsDetail];
    [self requestForAddress];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorFromString:@"f2f2f2"]]];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupNavigation {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [shareBtn addTarget:self action:@selector(onShareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:kGetImage(@"share_icon_black") forState:UIControlStateNormal];
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareBarBtn;
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kGoodsDetailCellName bundle:nil] forCellReuseIdentifier:kGoodsDetailCellID];
    self.tableView.tableHeaderView = [self tableHeaderView];
    self.tableView.tableFooterView = [self tableFooterView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBuyClicked)];
    [self.buyView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBuyClicked)];
    [self.vipBuyView addGestureRecognizer:tap2];
}

- (void)setupWebView {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 49)];
    webView.backgroundColor = [UIColor whiteColor];
    self.webView = webView;
}

- (UIView *)tableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth + 90)];
    self.headerView = headerView;
    
    NABannerView *bannerView = [[NABannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)
                                                         cardArray:[NSArray array]
                                                        clickBlock:nil];
    [headerView addSubview:bannerView];
    self.bannerView = bannerView;
    
    NAGoodsInformationView *informationView = [[NSBundle mainBundle] loadNibNamed:@"NAGoodsInformationView" owner:self options:nil].firstObject;
    informationView.frame = CGRectMake(0, kScreenWidth, kScreenWidth, 90);
    [headerView addSubview:informationView];
    self.informationView = informationView;
    
    return headerView;
}

- (void)resetSubviews {
    [self.bannerView setupWithCardArray:self.imgArr clickBlock:nil];
    if (!self.isChoseChild) {
        if (self.childrenArr.count > 0) {
            self.childModel = [NAGoodsChildModel yy_modelWithJSON:self.childrenArr[0]];
        } else {
            NAGoodsChildModel *childModel = [[NAGoodsChildModel alloc] init];
            childModel.price = self.goodsModel.price;
            childModel.second_class_cost = self.goodsModel.vip_price;
            self.childModel = childModel;
        }
    }
    [self.informationView setGoodsModel:self.goodsModel childModel:self.childModel tags:self.productTagsArr];
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth + self.informationView.height);
    
    self.vipPriceLabel.text = [NSString stringWithFormat:@"%@元", self.childModel.second_class_cost];
    [self.tableView reloadData];
}

- (UIView *)tableFooterView {
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.backgroundColor = kColorGraySeperator;
    footerLabel.font = [UIFont systemFontOfSize:13];
    footerLabel.text = @"继续拖动，查看图文详情";
    return footerLabel;
}

#pragma mark - <Net Request>
- (void)requestForGoodsDetail {
    NAAPIModel *model = [NAURLCenter goodsDetailConfigWithProductID:self.goodsModel.id];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        weakSelf.goodsModel = [NAGoodsModel yy_modelWithJSON:returnValue[@"parent_product"]];
        weakSelf.vipGradeArr = returnValue[@"member_class"];
        weakSelf.productTagsArr = returnValue[@"product_tags"];
        weakSelf.childrenArr = returnValue[@"child_products"];
        weakSelf.goodsHtml = [NSString stringWithFormat:@"%@", returnValue[@"product_detail"][@"detail"]];
        weakSelf.imgArr = returnValue[@"product_imgs"];
        if (weakSelf.imgArr.count > 0) {
            [weakSelf.bannerView setupWithCardArray:weakSelf.imgArr clickBlock:nil];
        }
        [weakSelf resetSubviews];
    } errorCodeBlock:nil failureBlock:nil];
}

- (void)requestForAddress {
    NAAPIModel *model = [NAURLCenter userAddressConfig];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        NSString *code = [NSString stringWithFormat:@"%@", returnValue[@"code"]];
        NSArray *addressArr = returnValue[@"address"];
        if (addressArr && addressArr.count > 0 && [code isEqualToString:@"0"]) {
            NSDictionary *dic = addressArr[0];
            weakSelf.addressModel = [NAAddressModel yy_modelWithJSON:dic];
        }
    } errorCodeBlock:nil failureBlock:nil];
}

#pragma mark - <Events>
- (void)onShareBtnClicked:(id)sender {
    if (self.childrenArr.count <=0) return;
    
    if (!self.shareView) {
        WeakSelf
        UMSocialMessageObject *msgObjc = [UMSocialMessageObject messageObject];
        msgObjc.text = @"信用体检报告";
        
        UMShareWebpageObject *shareWebpageObjc = [[UMShareWebpageObject alloc] init];
        shareWebpageObjc.webpageUrl = [NAURLCenter sharedGoodsDetailH5UrlWithGoodsID:self.goodsModel.id];
        shareWebpageObjc.title = self.goodsModel.title;
        NAGoodsChildModel *childModel = [NAGoodsChildModel yy_modelWithJSON:self.childrenArr[0]];
        shareWebpageObjc.descr = [NSString stringWithFormat:@"%@只要%@元", self.goodsModel.title, childModel.second_class_cost];
        shareWebpageObjc.thumbImage = self.imgArr.count > 0 ? [NSString stringWithFormat:@"%@", self.imgArr[0][@"url"]] : nil;
        msgObjc.shareObject = shareWebpageObjc;
        
        self.shareView = [[NAShareView alloc] initWithActionBlock:^(UMSocialPlatformType sharePlatform) {
            [[UMSocialManager defaultManager] shareToPlatform:sharePlatform messageObject:msgObjc currentViewController:weakSelf completion:^(id result, NSError *error) {
                if (error) return;
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                [weakSelf.shareView hide];
            }];
        }];
    }
    [self.shareView show];
}

- (void)onBuyClicked {
    if (self.goodsModel.secondary_feature_title && ![self.goodsModel.secondary_feature_title isEqualToString:@""] && self.childModel.secondary_feature.length <= 0) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请先选择%@", self.goodsModel.secondary_feature_title]];
    } else if (!self.addressModel && self.goodsModel.order_type == 3) {
        [SVProgressHUD showErrorWithStatus:@"请先选择收货地址"];
    } else {
        NAConfirmOrderModel *model = [[NAConfirmOrderModel alloc] init];
        model.ptypeId = self.childModel.id;
        model.ptype = self.childModel.main_feature;
        model.title = self.goodsModel.attraction;
        model.img = self.goodsModel.img;
        model.money = self.childModel.second_class_cost;
        model.orderType = [NSString stringWithFormat:@"%ld", self.goodsModel.order_type];
        UIViewController *toVC = [NAViewControllerCenter confirmOrderControllerWithModel:model];
        [NAViewControllerCenter transformViewController:self toViewController:toVC tranformStyle:NATransformStylePush needLogin:YES];
    }
}

- (void)gotoWebView {
    
    NSRange range = [self.goodsHtml rangeOfString:@"<p>"];
    if (range.location != NSNotFound) {
        NSMutableString *wholeHtml = [NSMutableString string];
        [wholeHtml appendString:@"<html><head><style></style></head>"];
        //使html中的图片自动适应屏幕宽度
        [wholeHtml appendString:@"<style>img{width:100%;height:auto;}</style>"];
        [wholeHtml appendString:@"<body style=\"font-size:24px\">"];
        [wholeHtml appendString:self.goodsHtml];
        [wholeHtml appendString:@"</body></html>"];
        
        [self.webView loadHTMLString:wholeHtml baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, -self.view.height, self.tableView.width, self.tableView.height);
        self.webView.frame = CGRectMake(0, kStatusBarH, self.webView.width, self.webView.height);
    }];
}

- (void)backToTableView {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, 0, self.tableView.width, self.tableView.height);
        self.webView.frame = CGRectMake(0, self.view.height, self.webView.width, self.webView.height);
    }];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.goodsModel.order_type == 3)
        return 3;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NAGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        NSString *content = @"";
        if (self.childModel.main_feature.length > 0 && self.childModel.secondary_feature.length > 0) {
            content = [NSString stringWithFormat:@"%@ %@", self.childModel.main_feature, self.childModel.secondary_feature];
        } else if (self.childModel.main_feature.length > 0 && self.childModel.secondary_feature.length <= 0) {
            content = [NSString stringWithFormat:@"%@", self.childModel.main_feature];
        }
        [cell setTitle:@"选择" content:content showArrow:YES];
        
    } else if (indexPath.row == 1) {
        [cell setTitle:@"数量" content:@"1" showArrow:NO];
    } else if (indexPath.row == 2) {
        [cell setTitle:@"送至" content:self.addressModel.address showArrow:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (!self.featureView) {
            self.featureView = [[NAGoodsFeatureView alloc] initWithTitle1:self.goodsModel.main_feature_title title2:self.goodsModel.secondary_feature_title childArr:self.childrenArr];
            WeakSelf
            self.featureView.block = ^(NAGoodsChildModel *childModel) {
                weakSelf.childModel = childModel;
                weakSelf.isChoseChild = YES;
                [weakSelf resetSubviews];
            };
        }
        [self.featureView show];
        
    } else if (indexPath.row == 2) {
        UIViewController *toVC = [NAViewControllerCenter addressControllerWithCompleteBlock:^(NAAddressModel *model) {
            self.addressModel = model;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [NAViewControllerCenter transformViewController:self toViewController:toVC tranformStyle:NATransformStylePush needLogin:YES];
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.tableView) {
        CGFloat number = self.tableView.contentSize.height - self.tableView.height > 0 ? self.tableView.contentSize.height - self.tableView.height : 0;
        if (scrollView.contentOffset.y - number > 40)
            [self gotoWebView];
    } else if (scrollView == self.webView.scrollView && scrollView.contentOffset.y < -60) {
        [self backToTableView];
    }
}


@end
