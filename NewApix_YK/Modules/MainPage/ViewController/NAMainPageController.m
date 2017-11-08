//
//  NAMainPageController.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAMainPageController.h"
#import "NAMainCardModel.h"
#import "NABannerView.h"
#import "NAMainPageCell.h"
#import "NAViewControllerCenter.h"
#import "NSAttributedString+NAExtension.h"
#import "FLAnimatedImage.h"

NSString *const kMainPageCellName = @"NAMainPageCell";
NSString *const kMainPageCellID = @"mainPageCell";

@interface NAMainPageController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NABannerView *bannerView;
/** banner下方的两排按钮 title imageName */
@property (nonatomic, strong) NSArray *line1BtnTitleArray;
@property (nonatomic, strong) NSArray *line2BtnTitleArray;
@property (nonatomic, strong) NSArray *line1BtnImageArray;
@property (nonatomic, strong) NSArray *line2BtnImageArray;

/** 卡片列表data */
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *bannerDataArray;
/** 商品列表页banner */
@property (nonatomic, strong) NSMutableArray *storeBannerArray;

@end

@implementation NAMainPageController
#pragma mark - <Lazy Load>
- (NSArray *)line1BtnTitleArray {
    if (!_line1BtnTitleArray) {
        _line1BtnTitleArray = @[@"我要赚钱", @"9块9秒杀", @"无息贷款"];
    }
    return _line1BtnTitleArray;
}
- (NSArray *)line1BtnImageArray {
    if (!_line1BtnImageArray) {
        _line1BtnImageArray = @[@"main_page_btn_money", @"main_page_btn_9.9", @"main_page_btn_loan"];
    }
    return _line1BtnImageArray;
}
- (NSArray *)line2BtnTitleArray {
    if (!_line2BtnTitleArray) {
        _line2BtnTitleArray = @[@"特价话费", @"视频会员", @"社区快讯", @"我的钱包"];
    }
    return _line2BtnTitleArray;
}
- (NSArray *)line2BtnImageArray {
    if (!_line2BtnImageArray) {
        _line2BtnImageArray = @[@"main_page_btn_phone", @"main_page_btn_video", @"main_page_btn_article", @"main_page_btn_wallet"];
    }
    return _line2BtnImageArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)bannerDataArray {
    if (!_bannerDataArray) {
        _bannerDataArray = [NSMutableArray array];
    }
    return _bannerDataArray;
}

- (NSMutableArray *)storeBannerArray {
    if (!_storeBannerArray) {
        _storeBannerArray = [NSMutableArray array];
    }
    return _storeBannerArray;
}

#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    [self setupTableView];
    [self loadData];
    [self addNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bannerView startAnimation];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.bannerView stopAnimation];
}

#pragma mark - <Private Method>
- (void)setupTableView {
    
    [self.mainTableView registerNib:[UINib nibWithNibName:kMainPageCellName bundle:nil] forCellReuseIdentifier:kMainPageCellID];
    self.mainTableView.tableHeaderView = [self createHeaderView];
    self.mainTableView.tableFooterView = [[NACommon sharedCommon] createNoMoreDataFooterView];
    
    // 上下拉刷新控件
    self.mainTableView.mj_header = [[NACommon sharedCommon] createMJRefreshGifHeaderWithTarget:self action:@selector(loadData)];
//    self.mainTableView.mj_footer = [[NACommon sharedCommon] createMJRefreshAutoGifFooterWithTarget:self action:@selector(loadMoreData)];
}

- (UIView *)createHeaderView {
    UIView *headerView = [[UIView alloc] init];
    
    // banner
    WeakSelf
    NABannerView *bannerView = [[NABannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)
                                                         cardArray:self.bannerDataArray
                                                        clickBlock:^(NAMainCardModel *cardModel) {
                                                            NSLog(@"点击了banner");
                                                            [weakSelf transformControlerWithModel:cardModel];
                                                        }];
    [headerView addSubview:bannerView];
    self.bannerView = bannerView;
    
    // 下方两排按钮view
    CGFloat imageWidth = 36;
    CGFloat btnHeight = 15 + imageWidth + 30 + 15;
    
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bannerView.frame) + 8, kScreenWidth, btnHeight * 2 + 1)];
    btnBgView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:btnBgView];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(btnBgView.frame));
    
    // 第一排
    for (int i=0; i<self.line1BtnTitleArray.count; i++) {
        
        NSString *btnTitle = self.line1BtnTitleArray[i];
        NSString *btnImage = self.line1BtnImageArray[i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/self.line1BtnTitleArray.count * i, 0, kScreenWidth/self.line1BtnTitleArray.count, btnHeight)];
        button.tag = 101 + i;
        [button setAttributedTitle:[NSAttributedString attributedStringWithImage:kGetImage(btnImage) imageWH:imageWidth title:btnTitle fontSize:12 titleColor:kColorTextBlack spacing:10] forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addTarget:self action:@selector(onMainBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnBgView addSubview:button];
        
        if (i == 0) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"new" withExtension:@"gif"];
            
            FLAnimatedImageView *gifImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(button.width/2 + 10, 10, 20, 20)];
            FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:url]];
            [gifImageView setAnimatedImage:gifImage];
            [button addSubview:gifImageView];
        }
        
    }
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, btnHeight, kScreenWidth - 30, 1)];
    lineView.backgroundColor = [UIColor colorFromString:@"f7f5f5"];
    [btnBgView addSubview:lineView];
    
    // 第二排
    for (int i=0; i<self.line2BtnTitleArray.count; i++) {
        
        NSString *btnTitle = self.line2BtnTitleArray[i];
        NSString *btnImage = self.line2BtnImageArray[i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/self.line2BtnTitleArray.count * i, CGRectGetMaxY(lineView.frame), kScreenWidth/self.line2BtnTitleArray.count, btnHeight)];
        button.tag = 101 + self.line1BtnTitleArray.count + i;
        [button setAttributedTitle:[NSAttributedString attributedStringWithImage:kGetImage(btnImage) imageWH:imageWidth title:btnTitle fontSize:12 titleColor:kColorTextBlack spacing:10] forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addTarget:self action:@selector(onMainBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnBgView addSubview:button];
    }
    
    return headerView;
}

- (void)addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChange) name:kNotificationNetChange object:nil];
}

- (void)netChange {
    NSLog(@"现在有网了！");
}

- (void)loadData {
    
    NAAPIModel *model = [NAURLCenter mainPageCardConfigWithVersion:[NSString stringWithFormat:@"%@", VERSION]];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        NSArray *cards = returnValue[@"cards"];
        if (cards && cards.count > 0) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.bannerDataArray removeAllObjects];
            [weakSelf.storeBannerArray removeAllObjects];
            
            for (NSDictionary *cardDic in cards) {
                NSNumber *cardType = cardDic[@"card_type"];
                if (![@[@(14), @(15), @(16), @(17), @(18), @(19), @(20)] containsObject:cardType]) {
                    if ([cardType isEqualToNumber:@(3)]) {
                        [weakSelf.bannerDataArray addObject:cardDic];
                    }
                    else if ([cardType isEqualToNumber:@(10)] || [cardType isEqualToNumber:@(11)]) {
                        [weakSelf.storeBannerArray addObject:cardDic];
                    }
                    else {
                        [weakSelf.dataArray addObject:cardDic];
                    }
                }
            }
            [weakSelf.mainTableView reloadData];
            [weakSelf.bannerView setupWithCardArray:weakSelf.bannerDataArray clickBlock:^(NAMainCardModel *cardModel) {
                NSLog(@"点击了banner");
                [weakSelf transformControlerWithModel:cardModel];
            }];
        }
        [weakSelf.mainTableView.mj_header endRefreshing];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        [weakSelf.mainTableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
        [weakSelf.mainTableView.mj_header endRefreshing];
    }];
}

// 上拉加载更多
//- (void)loadMoreData {
//}

/** 根据cardModel进行页面跳转 */
- (void)transformControlerWithModel:(NAMainCardModel *)model {
    
    // banner跳转
    if (model.card_type == 3) {
        switch (model.bottom_button_type) {
            case 0: {
                // 第三方web页
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 2: {
                // 攻略模块
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 3: {
                // 头条
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 4: {
                // 社区
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 5: {
                // 信用体检
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 6: {
                // 智能借款
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 7: {
                // 还款助手
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 8: {
                // 信用卡
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 9: {
                // 征信
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 10: {
                // 商城
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 11: {
                // 商品详情
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
                
            default:
                break;
        }
    }
    // 下方卡片跳转
    else {
        switch (model.card_type) {
            case 4: {
                // 热卡推荐
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 5: {
                // 智能推荐，第三方贷款 菠萝贷等
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 6: {
                // 会员文章
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 7: {
                // 视频卡
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 8: {
                // 商品详情
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 9: {
                // 商城页
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 12: {
                // 攻略
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 13: {
                // 无息贷款
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
            case 21: {
                // 新加非会员无息贷款
                [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter commonWebControllerWithCardModel:model isShowShareBtn:YES] tranformStyle:NATransformStylePush needLogin:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - <Event>
/** banner下方button点击事件 */
- (void)onMainBtnClicked:(UIButton *)button {
    UIViewController *toVC = nil;
    switch (button.tag - 100) {
        case 1:
            toVC = [NAViewControllerCenter makeMoneyController];
            break;
        case 2:
            toVC = [NAViewControllerCenter makeMoneyController];
            break;
        case 3:
            toVC = [NAViewControllerCenter makeMoneyController];
            break;
        case 4:
            toVC = [NAViewControllerCenter makeMoneyController];
            break;
        case 5:
            toVC = [NAViewControllerCenter makeMoneyController];
            break;
        case 6:
            toVC = [NAViewControllerCenter makeMoneyController];
            break;
        case 7:
            toVC = [NAViewControllerCenter makeMoneyController];
            break;
            
        default:
            break;
    }
    [NAViewControllerCenter transformViewController:self toViewController:toVC tranformStyle:NATransformStylePush needLogin:YES];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NAMainPageCell *cell = [tableView dequeueReusableCellWithIdentifier:kMainPageCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NAMainCardModel *model = [NAMainCardModel yy_modelWithJSON:self.dataArray[indexPath.row]];
    cell.cardModel = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NAMainCardModel *cardModel = [NAMainCardModel yy_modelWithJSON:self.dataArray[indexPath.row]];
    return cardModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NAMainCardModel *cardModel = [NAMainCardModel yy_modelWithJSON:self.dataArray[indexPath.row]];
    [self transformControlerWithModel:cardModel];
}

@end
