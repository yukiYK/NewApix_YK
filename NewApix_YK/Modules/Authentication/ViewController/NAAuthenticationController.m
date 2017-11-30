//
//  NAAuthenticationController.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/11/27.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAAuthenticationController.h"
#import "NAAuthenticationCell.h"
#import "NAAuthenticationTitleCell.h"
#import "NAAuthenticationFooterCell.h"

static NSString * const kAuthenticationCellName = @"NAAuthenticationCell";
static NSString * const kAuthenticationCellID = @"authenticationCell";
static NSString * const kAuthenticationTitleCellName = @"NAAuthenticationTitleCell";
static NSString * const kAuthenticationTitleCellID = @"authenticationTitleCell";
static NSString * const kAuthenticationFooterCellName = @"NAAuthenticationFooterCell";
static NSString * const kAuthenticationFooterCellID = @"authenticationFooterCell";
static NSString * const kAuthenticationHeaderID = @"authenticationHeader";

@interface NAAuthenticationController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, strong) NSArray *necessaryArr;
@property (nonatomic, strong) NSArray *necessaryImgArr;
@property (nonatomic, strong) NSArray *importantArr;
@property (nonatomic, strong) NSArray *importantImgArr;
@property (nonatomic, strong) NSArray *necessaryStateArr;
@property (nonatomic, strong) NSArray *importantStateArr;

@end

@implementation NAAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setupNextBtn];
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
}

- (void)setupNavigation {
    self.customTitleLabel.text = @"拼信用";
}

- (void)initData {
    self.necessaryArr = @[@"身份认证", @"通讯录", @"运营商", @"淘宝认证", @"京东认证"];
    self.necessaryImgArr = @[@"auth_id", @"auth_mail", @"auth_service", @"auth_tb", @"auth_jd"];
    self.importantArr = @[@"央行征信", @"借贷历史", @"基本信息", @"公积金", @"学信网"];
    self.importantImgArr = @[@"auth_bank", @"auth_loan", @"auth_baseinfo", @"auth_house", @"auth_edu"];
}

- (void)setupNextBtn {
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor colorFromString:@"cccccc"]];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    nextBtn.enabled = NO;
    [nextBtn addTarget:self action:@selector(onNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    self.nextBtn = nextBtn;
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(44);
    }];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.headerReferenceSize = CGSizeMake(0, (kScreenWidth - 30) * 0.12 + 30);
    
    UICollectionView *collectionView = [[UICollectionView alloc] init];
    collectionView.collectionViewLayout = layout;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = kColorGraySeperator;
    [collectionView registerNib:[UINib nibWithNibName:kAuthenticationCellName bundle:nil] forCellWithReuseIdentifier:kAuthenticationCellID];
    [collectionView registerNib:[UINib nibWithNibName:kAuthenticationTitleCellName bundle:nil] forCellWithReuseIdentifier:kAuthenticationTitleCellID];
    [collectionView registerNib:[UINib nibWithNibName:kAuthenticationFooterCellName bundle:nil] forCellWithReuseIdentifier:kAuthenticationFooterCellID];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAuthenticationHeaderID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.nextBtn.mas_top);
    }];
}

#pragma mark - <Net Request>
- (void)requestForAuthenticationStatus {
    NAAPIModel *model = [NAURLCenter authenticationStatusConfig];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        [NAAuthenticationModel analysisAuthentication:returnValue];
        NAAuthenticationModel *model = [NAAuthenticationModel sharedModel];
        weakSelf.necessaryStateArr = @[model.isp, model.jingdong];
        
    } errorCodeBlock:nil failureBlock:nil];
}


#pragma mark - <Events>
- (void)onNextBtnClicked:(UIButton *)button {
    
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (section) {
        case 0:
        case 2:
        case 4:
            number = 1;
            break;
        case 1:
            number = self.necessaryArr.count;
            break;
        case 3:
            number = self.importantArr.count;
            break;
            
        default:
            break;
    }
    return number;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAuthenticationHeaderID forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        for (UIView *view in headerView.subviews)
            [view removeFromSuperview];
    }
    headerView.backgroundColor = [UIColor whiteColor];
    
    if (!headerView) {
        headerView = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth - 30) * 0.12 + 30)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, (kScreenWidth - 30) * 0.12)];
        imageView.image = kGetImage(@"auth_progress");
        [headerView addSubview:imageView];
    }
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGSizeMake(kScreenWidth, (kScreenWidth - 30) * 0.12 + 30) : CGSizeZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NAAuthenticationTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAuthenticationTitleCellID forIndexPath:indexPath];
        cell.title = @"必填项";
        return cell;
    } else if (indexPath.section == 1) {
        NAAuthenticationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAuthenticationCellID forIndexPath:indexPath];
        [cell setCellModel:<#(NAAuthenticationCellModel *)#>]
        
    } else if (indexPath.section == 2) {
        NAAuthenticationTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAuthenticationTitleCellID forIndexPath:indexPath];
        cell.title = @"必填项";
        return cell;
    } else if (indexPath.section == 3) {
        
    } else if (indexPath.section == 4) {
        NAAuthenticationFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAuthenticationFooterCellID forIndexPath:indexPath];
        
    }
    
    
    return [[UICollectionViewCell alloc] init];
}

@end
