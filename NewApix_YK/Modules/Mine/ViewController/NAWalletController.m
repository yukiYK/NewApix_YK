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


@end

@implementation NAWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupSubviews];
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

- (void)setupSubviews {
    [self.tableView registerNib:[UINib nibWithNibName:kWalletCellName bundle:nil] forCellReuseIdentifier:kWalletCellID];
}

#pragma mark - <Events>
- (void)onBackClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onVisibleBtnClicked:(id)sender {
    
}

- (IBAction)onEncashmentBtnClicked:(id)sender {
    
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
