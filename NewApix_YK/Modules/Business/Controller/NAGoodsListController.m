//
//  NAGoodsListController.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/9.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAGoodsListController.h"
#import "NABannerView.h"
#import "NAGoodsListSmallCell.h"
#import "NAGoodsListBigCell.h"
#import "NAGoodsListTitleCell.h"
#import "NAGoodsListModel.h"
#import "NAGoodsModel.h"

static NSString * const kGoodsListBigCellName = @"NAGoodsListBigCell";
static NSString * const kGoodsListBigCellID = @"goodsListBigCell";
static NSString * const kGoodsListSmallCellName = @"NAGoodsListSmallCell";
static NSString * const kGoodsListSmallCellID = @"goodsListSmallCell";
static NSString * const kGoodsListTitleCellName = @"NAGoodsListTitleCell";
static NSString * const kGoodsListTitleCellID = @"goodsListTitleCell";
static NSString * const kGoodsListHeaderViewID = @"goodsListHeaderView";

@interface NAGoodsListController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NABannerView *bannerView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *goodsListTitleArr;
@property (nonatomic, strong) NSArray *allGoodsArr;

@end

@implementation NAGoodsListController
#pragma mark - <Lazy Load>
- (NSMutableArray *)goodsListTitleArr {
    if (!_goodsListTitleArr)
        _goodsListTitleArr = [NSMutableArray array];
    return _goodsListTitleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCollectionView];
    [self requestForGoods];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
    [self.bannerView startAnimation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.bannerView stopAnimation];
}

- (void)setupNavigation {
    self.customTitleLabel.text = @"9块9秒杀";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
}


- (void)setupCollectionView {
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.minimumLineSpacing = kCommonMargin;
    collectionLayout.minimumInteritemSpacing = kCommonMargin;
    collectionLayout.sectionInset = UIEdgeInsetsMake(0, kCommonMargin, kCommonMargin, kCommonMargin);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - kStatusBarH - kNavBarH) collectionViewLayout:collectionLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGoodsListHeaderViewID];
    [collectionView registerNib:[UINib nibWithNibName:kGoodsListBigCellName bundle:nil] forCellWithReuseIdentifier:kGoodsListBigCellID];
    [collectionView registerNib:[UINib nibWithNibName:kGoodsListSmallCellName bundle:nil] forCellWithReuseIdentifier:kGoodsListSmallCellID];
    [collectionView registerNib:[UINib nibWithNibName:kGoodsListTitleCellName bundle:nil] forCellWithReuseIdentifier:kGoodsListTitleCellID];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}


#pragma mark - <Net Request>
- (void)requestForGoods {
    NAAPIModel *model = [NAURLCenter goodsListConfig];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        weakSelf.allGoodsArr = returnValue[@"windows"] ? returnValue[@"windows"] : [NSArray array];
        for (NSDictionary *dict in weakSelf.allGoodsArr) {
            [weakSelf.goodsListTitleArr addObject:dict[@"name"]];
        }
        [weakSelf.collectionView reloadData];
    } errorCodeBlock:nil failureBlock:nil];
}


#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.goodsListTitleArr.count * 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0 || section%2 == 0)
        return 1;
    else {
        NSArray *itemArr = self.allGoodsArr[(section - 1)/2][@"products"];
        return itemArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0 || section % 2 == 0) {
        NAGoodsListTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsListTitleCellID forIndexPath:indexPath];
        NAGoodsListModel *goodsListmodel = [NAGoodsListModel yy_modelWithJSON:self.allGoodsArr[section/2]];
        cell.title = goodsListmodel.name;
        return cell;
    } else {
        NAGoodsListModel *goodsListmodel = [NAGoodsListModel yy_modelWithJSON:self.allGoodsArr[(section - 1)/2]];
        NAGoodsModel *goodsModel = [NAGoodsModel yy_modelWithJSON:goodsListmodel.products[indexPath.item]];
        if (goodsListmodel.window_type == 2) {
            NAGoodsListBigCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsListBigCellID forIndexPath:indexPath];
            cell.goodsModel = goodsModel;
            return cell;
        } else if (goodsListmodel.window_type == 3) {
            NAGoodsListSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsListSmallCellID forIndexPath:indexPath];
            cell.goodsModel = goodsModel;
            return cell;
        }
    }
    return [[UICollectionViewCell alloc] init];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:kGoodsListHeaderViewID
                                                                                   forIndexPath:indexPath];
    headView.backgroundColor = [UIColor whiteColor];
    //    添加BannerView
    NABannerView *bannerView = [[NABannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)
                                                         cardArray:self.bannerDataArray
                                                        clickBlock:^(NAMainCardModel *cardModel) {
                                                            NSLog(@"点击了banner");
                                                        }];
    [headView addSubview:bannerView];
    self.bannerView = bannerView;
    return headView;
}

// 设置section头视图的参考大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return CGSizeMake(kScreenWidth, kScreenWidth/2);
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter phonePayController] tranformStyle:NATransformStylePush needLogin:NO];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section % 2 == 0)
        return CGSizeMake(kScreenWidth - 30, 45);
    
    NAGoodsListModel *goodsListmodel = [NAGoodsListModel yy_modelWithJSON:self.allGoodsArr[(indexPath.section - 1)/2]];
    if (goodsListmodel.window_type == 2) {
        CGFloat width = (kScreenWidth - 46)/2;
        return CGSizeMake(width, width + 124);
    } else if (goodsListmodel.window_type == 3) {
        CGFloat width = (kScreenWidth - 60)/3;
        return CGSizeMake(width, width + 128);
    }
    return CGSizeZero;
}

@end
