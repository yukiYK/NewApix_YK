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
#import "NAMineWalletModel.h"

NSString * const kMineCell = @"mineCell";

@interface NAMineController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NAMineCell *feedbackCell;
@property (nonatomic, strong) NAMineHeaderView *mineHeaderView;
// tableView数据array
@property (nonatomic, strong) NSArray *array;
/** 用户信息 */
@property (nonatomic, strong) NAUserInfoModel *userModel;
/** 钱包信息 */
@property (nonatomic, strong) NAMineWalletModel *walletModel;
@property (nonatomic, assign) BOOL isNewRedPacket;
/** 会员状态 */
@property (nonatomic, assign) NAUserStatus userStatus;
/** 会员到期日期 */
@property (nonatomic, copy) NSString *vipEndDate;
/** 会员卡图片urlStr */
@property (nonatomic, copy) NSString *vipSkin;

/** 会员礼品状态 1:已领取 其他:未领取 */
@property (nonatomic, assign) NSInteger giftStatus;

/** 贷款记录数据 */
@property (nonatomic, strong) NSArray *loanArray;

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
    
    self.userStatus = NAUserStatusNormal;
    [self setupTableView];
    [self requestForLoanList];
    [self requestForRedPacket];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    
    [self requestForUserInfo];
    [self requestForOrderInfo];
    [self requestForGiftStatus];
    [NACommon loadUserStatusComplete:^(NAUserStatus userStatus, NSString *vipEndDate, NSString *vipSkin) {
        self.userStatus = userStatus;
        self.vipEndDate = vipEndDate;
        self.vipSkin = vipSkin;
        [self.tableView reloadData];
        WeakSelf
        [self.mineHeaderView setUserStatus:userStatus endDate:vipEndDate vipCardUrl:vipSkin vipImageBlock:^{
            [weakSelf onVIPClicked];
        }];
    }];
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
    WeakSelf
    self.mineHeaderView = [[NAMineHeaderView alloc] initWithUserStatus:[NACommon sharedCommon].userStatus settingsBlock:^{
        [weakSelf onSettingBtnClicked];
    } orderBlock:^(NSInteger btnTag) {
        [weakSelf onOrderClicked:0];
    }];
    tableView.tableHeaderView = self.mineHeaderView;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - <Net Request>
- (void)requestForUserInfo {
    
    NAAPIModel *model = [NAURLCenter mineUserInfoConfig];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    [manager setRequestSerializerForPost];
    
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        if ([returnValue[@"code"] integerValue] == -1) {
        } else if ([returnValue[@"apix_login_code"] integerValue] == -1) {
            [NAUserTool removeAllUserDefaults];
            [SVProgressHUD showErrorWithStatus:@"您的账号已在别处登录，请重新登录"];
//            [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter loginController] tranformStyle:NATransformStylePush needLogin:NO];
        } else {
            NAUserInfoModel *model = [NAUserInfoModel yy_modelWithJSON:returnValue[@"data"]];
            self.userModel = model;
            self.mineHeaderView.userInfo = model;
        }
    } errorCodeBlock:nil failureBlock:nil];
}

- (void)requestForRedPacket {
    NAAPIModel *model = [NAURLCenter redPacketConfig];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        weakSelf.walletModel = [NAMineWalletModel yy_modelWithJSON:returnValue];
        
        NSInteger count = weakSelf.walletModel.transaction.count;
        if (count > [NAUserTool getRedPacketCount]) self.isNewRedPacket = YES;
        
        [NAUserTool saveRedPacketCount:count];
        
        [weakSelf.tableView reloadData];
    } errorCodeBlock:nil failureBlock:nil];
}

- (void)requestForGiftStatus {
    NAAPIModel *model = [NAURLCenter vipPresentConfig];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        NSString *code = [NSString stringWithFormat:@"%@", returnValue[@"code"]];
        weakSelf.giftStatus = [code integerValue];
        
        [weakSelf.tableView reloadData];
    } errorCodeBlock:nil failureBlock:nil];
}

- (void)requestForOrderInfo {
    
    NAAPIModel *model = [NAURLCenter mineOrderInfoConfig];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        NSArray *countArr = returnValue[@"counts"];
        
        NAMineOrderModel *orderModel = [NAMineOrderModel yy_modelWithJSON:countArr[0]];
        NSInteger paid = [orderModel.paid integerValue];
        NSInteger success = [orderModel.success integerValue];
        NSInteger refound = [orderModel.refound integerValue];
        NSInteger all = paid + success + refound;
        orderModel.transactions = [NSString stringWithFormat:@"%ld", all];
        
        [weakSelf.mineHeaderView setOrderModel:orderModel orderBlock:^(NSInteger btnTag) {
            // TODO 跳转订单列表页
            [weakSelf onOrderClicked:btnTag];
        }];
    } errorCodeBlock:nil failureBlock:nil];
}

- (void)requestForLoanList {
    NAAPIModel *model = [NAURLCenter mineLoanListConfig];
    
    [self.netManager GET:[NAURLCenter urlWithType:model.requestUrlType pathArray:model.pathArr] parameters:model.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        
    } failure:nil];
}

#pragma mark - <Events>
// 跳转到 设置页
- (void)onSettingBtnClicked {
    UIViewController *settingsVC = [NAViewControllerCenter settingsControllerWithModel:self.userModel];
    [NAViewControllerCenter transformViewController:self
                                   toViewController:settingsVC
                                      tranformStyle:NATransformStylePush
                                          needLogin:YES];
}

// 跳转到 订单列表页
- (void)onOrderClicked:(NSInteger)btnTag {
    
}

// 跳转到 美信会员
- (void)onVIPClicked {
    [NAViewControllerCenter transformViewController:self
                                   toViewController:[NAViewControllerCenter meixinVIPControllerWithIsFromGiftCenter:NO]
                                      tranformStyle:NATransformStylePush
                                          needLogin:NO];
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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { // 美信会员
            UIColor *detailColor = kColorTextYellow;
            switch (self.userStatus) {
                case NAUserStatusVIPForever:
                    model.detail = @"终身会员";
                    break;
                case NAUserStatusVIP:
                    model.detail = [NSString stringWithFormat:@"V会员剩余%ld天", [NACommon getVIPRemainingDays:self.vipEndDate]];
                    detailColor = kColorTextRed;
                    break;
                case NAUserStatusOverdue:
                    model.detail = @"会员已到期";
                    break;
                    
                default:
                    model.detail = @"暂未开通会员";
                    break;
            }
            [cell setModel:model];
            [cell setDetailTextColor:detailColor bgColor:nil];
        } else if (indexPath.row == 1) { // 礼品中心
            if (self.giftStatus != 1) {
                model.detail = @"一大波礼物来袭";
                [cell setModel:model];
                [cell setDetailTextColor:kColorTextRed bgColor:nil];
                [cell setRightIcon:@"flower_present"];
            } else [cell setModel:model];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1 && self.isNewRedPacket) {
            model.detail = @"【有新的红包请查看】";
            [cell setModel:model];
            [cell showRedPoint:YES];
        } else if (indexPath.row == 2) {
            [cell setModel:model];
            self.feedbackCell = cell;
        } else [cell setModel:model];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击跳转");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NAMineModel *model = self.array[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self onVIPClicked];
        }
        else if (indexPath.row == 1) {
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter presentCenterController]
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
