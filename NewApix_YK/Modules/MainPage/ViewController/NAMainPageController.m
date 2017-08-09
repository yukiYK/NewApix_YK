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

NSString *const kMainPageCellName = @"NAMainPageCell";
NSString *const kMainPageCellID = @"mainPageCell";

@interface NAMainPageController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NABannerView *bannerView;


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *bannerDataArray;
/** 商品列表页banner */
@property (nonatomic, strong) NSMutableArray *storeBannerArray;

@end

@implementation NAMainPageController
#pragma mark - <Lazy Load>
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
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

#pragma mark - <Private Method>
- (void)setupTableView {
    self.mainTableView.mj_header = [[NACommon sharedCommon] createMJRefreshGifHeaderWithTarget:self action:@selector(loadData)];
    self.mainTableView.mj_footer = [[NACommon sharedCommon] createMJRefreshAutoGifFooterWithTarget:self action:@selector(loadMoreData)];
    [self.mainTableView registerNib:[UINib nibWithNibName:kMainPageCellName bundle:nil] forCellReuseIdentifier:kMainPageCellID];
}


- (void)loadData {
    
    NSMutableArray *pathArray = [NSMutableArray arrayWithObjects:@"api", @"cards", nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"version"] = @"2.9.2";
    
    WeakSelf
    [self.netManager netRequestGETWithRequestURL:[NAHTTPSessionManager urlWithType:NARequestURLTypeAPIX pathArray:pathArray]
                                       parameter:params
                                returnValueBlock:^(NSDictionary *returnValue) {
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
                                                }
                                                else if ([cardType isEqualToNumber:@(10)] || [cardType isEqualToNumber:@(11)]) {
                                                }
                                                else {
                                                }
                                            }
                                        }
                                        
                                        
                                    }
                                }
                                  errorCodeBlock:^(NSString *code, NSString *msg) {
                                      
                                      [SVProgressHUD showErrorWithStatus:msg];
                                  }
                                    failureBlock:^(NSError *error) {
                                        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
                                    }];
}

- (void)loadMoreData {
}


- (void)transformControlerWithModel:(NAMainCardModel *)model {
    
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NAMainPageCell *cell = [tableView dequeueReusableCellWithIdentifier:kMainPageCellID forIndexPath:indexPath];
    NAMainCardModel *model = [NAMainCardModel yy_modelWithJSON:self.dataArray[indexPath.row]];
    cell.cardMadel = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NAMainCardModel *cardModel = [NAMainCardModel yy_modelWithJSON:self.dataArray[indexPath.row]];
    return cardModel.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NABannerView *bannerView = [[NABannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)
                                                         cardArray:self.bannerDataArray
                                                        clickBlock:^(NAMainCardModel *cardModel) {
                                                            NSLog(@"点击了banner");
                                                        }];
    
    self.bannerView = bannerView;
    return bannerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NAMainCardModel *cardModel = [NAMainCardModel yy_modelWithJSON:self.dataArray[indexPath.row]];
    [self transformControlerWithModel:cardModel];
}

@end
