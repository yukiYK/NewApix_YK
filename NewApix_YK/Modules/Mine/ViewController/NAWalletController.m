//
//  NAWalletController.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAWalletController.h"
#import "NAWalletCell.h"

static NSString * const kWalletCellID = @"walletCell";
static NSString * const kWalletCellName = @"NAWalletCell";

@interface NAWalletController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *visibleBtn;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanMoneyLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *encashmentBtn;

@property (nonatomic, strong) UIView *footerView;

@end
//210 216
@implementation NAWalletController
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.tableView.bounds.size.height - 44)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 210, 216)];
        imageView.center = _footerView.center;
        imageView.image = kGetImage(@"list_empty");
        [_footerView addSubview:imageView];
    }
    return _footerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupTableView];
    [self resetFooterView];
    if (self.walletModel) [self setupWalletModel];
    else [self requestForWallet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorFromString:@"f2f2f2"]]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupNavigation {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromString:@"86a8d8"];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.customTitleLabel.text = @"钱包";
    self.customTitleLabel.textColor = [UIColor whiteColor];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 20, 30)];
    [left addTarget:self action:@selector(onBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [left setImage:kGetImage(kImageBackWhite) forState:UIControlStateNormal];
    [left setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBut;
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kWalletCellName bundle:nil] forCellReuseIdentifier:kWalletCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)resetFooterView {
    if (self.walletModel.transaction.count <= 0)
        self.tableView.tableFooterView = self.footerView;
    else self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupWalletModel {
    self.moneyLabel.text = self.walletModel.balance;
    
    self.saveMoneyLabel.text = [NSString stringWithFormat:@"帮你省钱:%@元", self.walletModel.advantage];
    self.incomeLabel.text = self.walletModel.income;
    self.loanMoneyLabel.text = self.walletModel.loan;
}

- (void)requestForWallet {
    NAAPIModel *model = [NAURLCenter redPacketConfig];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        weakSelf.walletModel = [NAWalletModel yy_modelWithJSON:returnValue];
        NSInteger count = weakSelf.walletModel.transaction.count;
        [NAUserTool saveRedPacketCount:count];
        [weakSelf.tableView reloadData];
        [weakSelf setupWalletModel];
        [weakSelf resetFooterView];
    } errorCodeBlock:nil failureBlock:nil];
}

#pragma mark - <Events>
- (void)onBackClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onVisibleBtnClicked:(id)sender {
    self.visibleBtn.selected = !self.visibleBtn.selected;
    
    self.moneyLabel.text = self.visibleBtn.selected ? @"****" : self.walletModel.balance;
}

- (IBAction)onEncashmentBtnClicked:(id)sender {
    [NAViewControllerCenter transformViewController:self
                                   toViewController:[NAViewControllerCenter encashmentControllerWithAllMoney:self.walletModel.balance]
                                      tranformStyle:NATransformStylePush
                                          needLogin:NO];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.walletModel.transaction.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NAWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:kWalletCellID forIndexPath:indexPath];
    NAWalletTransationModel *transationModel = [NAWalletTransationModel yy_modelWithJSON:self.walletModel.transaction[indexPath.row]];
    cell.transationModel = transationModel;
    return cell;
}


@end
