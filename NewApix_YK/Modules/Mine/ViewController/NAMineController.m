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
@property (nonatomic, strong) NAMineHeaderView *mineHeaderView;

@property (nonatomic, strong) NSArray *array;


@property (nonatomic, assign) BOOL isVipForever;

@end

@implementation NAMineController
#pragma mark - <Lazy Load>
- (NSArray *)array {
    if (!_array) {
        NAMineModel *model1 = [[NAMineModel alloc] initWithTitle:@"美信会员" icon:@"mine_vip" detail:@""];
        NAMineModel *model3 = [[NAMineModel alloc] initWithTitle:@"礼品中心" icon:@"mine_address" detail:@""];
        NAMineModel *model4 = [[NAMineModel alloc] initWithTitle:@"贷款记录" icon:@"mine_loan_record" detail:@""];
        NAMineModel *model5 = [[NAMineModel alloc] initWithTitle:@"钱包" icon:@"mine_wallet" detail:@""];
        NAMineModel *model6 = [[NAMineModel alloc] initWithTitle:@"用户反馈" icon:@"mine_message" detail:@""];
        _array = [NSArray arrayWithObjects:@[model1, model3], @[model4, model5, model6], nil];
    }
    return _array;
}

#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kColorHeaderGray;
    
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    
    [self loadUserInfo];
    [self loadVipInfo];
    [self loadOrderInfo];
}

#pragma mark - <Private Method>
- (void)setupNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self hideBackBtn];
    self.customTitleLabel.text = @"会员中心";
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingBtnClicked)];
    
    [self.navigationItem setRightBarButtonItem:buttonItem];
}

- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarH - kStatusBarH - kTabBarH) style:UITableViewStylePlain];
    [tableView registerNib:[UINib nibWithNibName:@"NAMineCell" bundle:nil] forCellReuseIdentifier:kMineCell];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mineHeaderView = [[NAMineHeaderView alloc] initWithUserStatus:[NACommon sharedCommon].userStatus];
    tableView.tableHeaderView = self.mineHeaderView;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)loadUserInfo {
    
    NAAPIModel *model = [NAURLCenter mineUserInfoConfig];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NAUserTool getDeviceId] forHTTPHeaderField:@"deviceid"];
    [manager.requestSerializer setValue:[NAUserTool getSystemVersion] forHTTPHeaderField:@"systemversion"];
    [manager.requestSerializer setValue:[NAUserTool getEquipmentType] forHTTPHeaderField:@"equipmenttype"];
    
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        if ([returnValue[@"code"] integerValue] == -1) {
        }
        else if ([returnValue[@"apix_login_code"] integerValue] == -1) {
            [NAUserTool removeAllUserDefaults];
            [SVProgressHUD showErrorWithStatus:@"您的账号已在别处登录，请重新登录"];
//            [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter loginController] tranformStyle:NATransformStylePush needLogin:NO];
        }
        else {
            NAUserInfoModel *model = [NAUserInfoModel yy_modelWithJSON:returnValue[@"data"]];
            self.mineHeaderView.userInfo = model;
        }
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)loadVipInfo {
    NAAPIModel *model = [NAURLCenter mineVipInfoConfig];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)loadOrderInfo {
    
    NAAPIModel *model = [NAURLCenter mineOrderInfoConfig];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)loadLoanList {
    NAAPIModel *model = [NAURLCenter mineLoanListConfig];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - <Events>
- (void)onSettingBtnClicked {
    [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter settingsController] tranformStyle:NATransformStylePush needLogin:NO];
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
    NAMineModel *model = self.array[indexPath.section][indexPath.row];
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击跳转");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NAMineModel *model = self.array[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter meixinVIPControllerWithIsFromGiftCenter:NO]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:NO];
        }
        else if (indexPath.row == 1) {
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter presentCenterControllerWithIsVipForever:self.isVipForever]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:YES];
        }
    }
    else {
        if (indexPath.row == 0) {
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter addressController]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:YES];
        }
        else if (indexPath.row == 1) {
        }
        else if (indexPath.row == 2) {
        }
    }
}

@end
