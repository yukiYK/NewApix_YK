//
//  NAMineController.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAMineController.h"
#import "NAMineCell.h"
#import "NAMineHeaderView.h"
#import "NAUserInfoModel.h"

NSString * const kMineCell = @"mineCell";

@interface NAMineController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@end

@implementation NAMineController
#pragma mark - <Lazy Load>
- (NSArray *)array {
    if (!_array) {
        NAMineModel *model1 = [[NAMineModel alloc] initWithTitle:@"美信会员" icon:@"mine_vip" detail:@""];
        NAMineModel *model2 = [[NAMineModel alloc] initWithTitle:@"钱包" icon:@"mine_wallet" detail:@""];
        NAMineModel *model3 = [[NAMineModel alloc] initWithTitle:@"收货地址" icon:@"mine_address" detail:@""];
        NAMineModel *model4 = [[NAMineModel alloc] initWithTitle:@"贷款记录" icon:@"mine_loan_record" detail:@""];
        NAMineModel *model5 = [[NAMineModel alloc] initWithTitle:@"推荐贷款" icon:@"mine_ commend" detail:@""];
        NAMineModel *model6 = [[NAMineModel alloc] initWithTitle:@"用户反馈" icon:@"mine_message" detail:@""];
        _array = [NSArray arrayWithObjects:@[model1, model2, model3], @[model4, model5, model6], nil];
    }
    return _array;
}

#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kColorHeaderGray;
    
    [self setupNavigationBar];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadUserInfo];
    [self loadVipInfo];
    [self loadOrderInfo];
}



#pragma mark - <Private Method>
- (void)setupNavigationBar {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleLabel.text = @"会员中心";
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingBtnClicked)];
    
    [self.navigationItem setRightBarButtonItem:buttonItem];
    [self.navigationItem setTitleView:titleLabel];
}

- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarH + kStatusBarH, kScreenWidth, kScreenHeight - kNavBarH - kStatusBarH - kTabBarH) style:UITableViewStylePlain];
    [tableView registerNib:[UINib nibWithNibName:@"NAMineCell" bundle:nil] forCellReuseIdentifier:kMineCell];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = [[NAMineHeaderView alloc] initWithUserStatus:[NACommon sharedCommon].userStatus];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)loadUserInfo {
    
    NAAPIModel *model = [NAURLCenter mineUserInfoConfigWithToken:[NACommon getToken]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[defaults objectForKey:@"deviceid"] forHTTPHeaderField:@"deviceid"];
    [manager.requestSerializer setValue:[defaults objectForKey:@"systemversion"] forHTTPHeaderField:@"systemversion"];
    [manager.requestSerializer setValue:[defaults objectForKey:@"equipmenttype"] forHTTPHeaderField:@"equipmenttype"];
    
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)loadVipInfo {
    NAAPIModel *model = [NAURLCenter mineVipInfoConfigWithToken:[NACommon getToken]];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)loadOrderInfo {
    
    NAAPIModel *model = [NAURLCenter mineOrderInfoConfigWithToken:[NACommon getToken]];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)loadLoanList {
    NAAPIModel *model = [NAURLCenter mineLoanListConfigWithToken:[NACommon getToken]];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - <Events>
- (void)onSettingBtnClicked {
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    view.backgroundColor = kColorHeaderGray;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.array[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NAMineCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineCell forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NAMineModel *model = self.array[indexPath.section][indexPath.row];
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击跳转");
}

@end
