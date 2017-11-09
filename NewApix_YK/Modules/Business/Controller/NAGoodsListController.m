//
//  NAGoodsListController.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/9.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAGoodsListController.h"
#import "NABannerView.h"

@interface NAGoodsListController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NABannerView *bannerView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation NAGoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBannerView];
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
}

- (void)setupNavigation {
    self.customTitleLabel.text = @"9块9秒杀";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupBannerView {
    NABannerView *bannerView = [[NABannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)
                                                         cardArray:self.bannerDataArray
                                                        clickBlock:^(NAMainCardModel *cardModel) {
                                                            NSLog(@"点击了banner");
                                                        }];
    [self.view addSubview:bannerView];
    self.bannerView = bannerView;
}

- (void)setupCollectionView {
    UICollectionViewLayout *collectionViewLayout = [[UICollectionViewLayout alloc] init];
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bannerView.frame), kScreenWidth, self.view.height - self.bannerView.height) collectionViewLayout:collectionViewLayout];
    
    
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}


#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>


#pragma mark - <UICollectionViewDelegateFlowLayout>

@end
