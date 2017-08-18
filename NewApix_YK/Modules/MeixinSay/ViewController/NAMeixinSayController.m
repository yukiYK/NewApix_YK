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

@interface NAMeixinSayController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

/** 头部两个button */
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITableView *essenceTableView;
@property (nonatomic, strong) UITableView *communityTableView;


@property (nonatomic, strong) NSMutableArray *essenceDataArray;
@property (nonatomic, strong) NSMutableArray *communityDataArray;

@end

@implementation NAMeixinSayController
#pragma mark - <Lazy Load>
- (NSMutableArray *)essenceDataArray {
    if (!_essenceDataArray) {
        _essenceDataArray = [NSMutableArray array];
    }
    return _essenceDataArray;
}

- (NSMutableArray *)communityDataArray {
    if (!_communityDataArray) {
        _communityDataArray = [NSMutableArray array];
    }
    return _communityDataArray;
}


#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    UITableView *essenceTableView = [[UITableView alloc] initWithFrame:self.scrollView.bounds];
    essenceTableView.delegate = self;
    essenceTableView.dataSource = self;
    essenceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [essenceTableView registerNib:[UINib nibWithNibName:kEssenceCellName bundle:nil] forCellReuseIdentifier:kEssenceCellID];
    essenceTableView.mj_header = [[NACommon sharedCommon] createMJRefreshGifHeaderWithTarget:self action:@selector(loadEssenceData)];
    essenceTableView.mj_footer = [[NACommon sharedCommon] createMJRefreshAutoGifFooterWithTarget:self action:@selector(loadMoreEssenceData)];
    [scrollView addSubview:essenceTableView];
    self.essenceTableView = essenceTableView;
    
    UITableView *communityTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, scrollView.bounds.size.height)];
    communityTableView.delegate = self;
    communityTableView.dataSource = self;
    communityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [communityTableView registerNib:[UINib nibWithNibName:kCommunityCellName bundle:nil] forCellReuseIdentifier:kCommunityCellID];
    communityTableView.mj_header = [[NACommon sharedCommon] createMJRefreshGifHeaderWithTarget:self action:@selector(loadCommunityData)];
    communityTableView.mj_footer = [[NACommon sharedCommon] createMJRefreshAutoGifFooterWithTarget:self action:@selector(loadMoreCommunityData)];
    [scrollView addSubview:communityTableView];
    self.communityTableView = communityTableView;
}


- (void)loadEssenceData {
    
}

- (void)loadMoreEssenceData {
    
}

- (void)loadCommunityData {
    
}

- (void)loadMoreCommunityData {
    
}

#pragma mark - <Event>
- (void)onLeftBtnClicked:(UIButton *)sender {
    if (sender.selected) return;
    
    sender.selected = YES;
    
}

- (void)onRightBtnClicked:(UIButton *)sender {
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.essenceTableView)
        return self.essenceDataArray.count;
    return self.communityDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.essenceTableView) {
        NAEssenceCell *essenceCell = [tableView dequeueReusableCellWithIdentifier:kEssenceCellID forIndexPath:indexPath];
        return essenceCell;
    }
    else {
        NACommunityCell *communityCell = [tableView dequeueReusableCellWithIdentifier:kCommunityCellID forIndexPath:indexPath];
        return communityCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

@end
