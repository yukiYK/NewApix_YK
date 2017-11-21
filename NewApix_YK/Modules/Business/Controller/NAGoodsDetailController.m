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

@property (nonatomic, copy) NSString *html;

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
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 49)];
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupTableView];
    [self requestForGoodsDetail];
    [self requestForAddress];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
        NAGoodsChildModel *childModel = [[NAGoodsChildModel alloc] init];
        childModel.price = self.goodsModel.price;
        childModel.second_class_cost = self.goodsModel.vip_price;
        self.childModel = childModel;
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
    if (self.childrenArr.count <=0 || self.imgArr.count <= 0) return;
    
    if (!self.shareView) {
        WeakSelf
        UMSocialMessageObject *msgObjc = [UMSocialMessageObject messageObject];
        msgObjc.text = @"信用体检报告";
        
        UMShareWebpageObject *shareWebpageObjc = [[UMShareWebpageObject alloc] init];
        shareWebpageObjc.webpageUrl = [NAURLCenter sharedGoodsDetailH5UrlWithGoodsID:self.goodsModel.id];
        shareWebpageObjc.title = self.goodsModel.title;
        NAGoodsChildModel *childModel = [NAGoodsChildModel yy_modelWithJSON:self.childrenArr[0]];
        shareWebpageObjc.descr = [NSString stringWithFormat:@"%@只要%@元", self.goodsModel.title, childModel.second_class_cost];
        shareWebpageObjc.thumbImage = [NSString stringWithFormat:@"%@", self.imgArr[0][@"url"]];
        msgObjc.shareObject = shareWebpageObjc;
        
        self.shareView = [[NAShareView alloc] initWithActionBlock:^(UMSocialPlatformType sharePlatform) {
            [[UMSocialManager defaultManager] shareToPlatform:sharePlatform messageObject:msgObjc currentViewController:weakSelf completion:^(id result, NSError *error) {
                if (error) return;
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
//                [weakSelf requestForShareSuccess];
                [weakSelf.shareView hide];
            }];
        }];
    }
    [self.shareView show];
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
                [weakSelf resetSubviews];
            };
        }
        [self.featureView show];
        
    } else if (indexPath.row == 2) {
        
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        
    } else if (scrollView == self.webView.scrollView) {
        
    }
}


@end
