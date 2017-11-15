//
//  NABankCardsController.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/9.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NABankCardsController.h"
#import "NABankCardCell.h"
#import "NAAuthenticationModel.h"

static NSString * const kBankCardCell = @"bankCardCell";
static NSString * const kBankCardCellName = @"NABankCardCell";

@interface NABankCardsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *noBankCardView;

@property (nonatomic, strong) NSMutableArray *bankCardArr;

@end

@implementation NABankCardsController
#pragma mark - <Lazy Load>
- (NSMutableArray *)bankCardArr {
    if (!_bankCardArr) {
        _bankCardArr = [NSMutableArray array];
    }
    return _bankCardArr;
}

- (UIView *)noBankCardView {
    if (!_noBankCardView) {
        _noBankCardView = [[UIView alloc] initWithFrame:self.view.bounds];
        _noBankCardView.backgroundColor = kColorHeaderGray;
        CGFloat viewHeight = _noBankCardView.height;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-185)/2, (viewHeight-138)/2, 185, 138)];
        imageView.image = kGetImage(@"bankcard_simple");
        [_noBankCardView addSubview:imageView];
        
        UILabel *addCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.y - 27 - 35, kScreenWidth, 27)];
        addCardLabel.text = @"请点击右上角添加银行卡";
        addCardLabel.textAlignment = NSTextAlignmentCenter;
        addCardLabel.font = [UIFont systemFontOfSize:17];
        addCardLabel.textColor = [UIColor colorFromString:@"AAAAAA"];
        [_noBankCardView addSubview:addCardLabel];
        
        UILabel *noCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, addCardLabel.y - 38 - 17, kScreenWidth, 38)];
        noCardLabel.text = @"暂无绑定的银行卡";
        noCardLabel.textAlignment = NSTextAlignmentCenter;
        noCardLabel.font = [UIFont systemFontOfSize:17];
        [_noBankCardView addSubview:noCardLabel];
    }
    return _noBankCardView;
}

#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kColorHeaderGray;
    [self setupNavigation];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestForBankCards];
}

- (void)setupNavigation {
    self.customTitleLabel.text = @"银行卡管理";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"bank_add") style:UIBarButtonItemStyleDone target:self action:@selector(onAddBankCardClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:kBankCardCellName bundle:nil] forCellReuseIdentifier:kBankCardCell];
    tableView.tableFooterView = [self footerView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (UIView *)footerView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 20)];
    tipLabel.text = @"为了保证资金交易安全，只支持绑定3张银行卡";
    tipLabel.textColor = [UIColor colorFromString:@"89abe3"];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:tipLabel];
    
    return footerView;
}

- (BOOL)isNoBankCardViewOn {
    for (UIView *view in self.view.subviews) {
        if (view == self.noBankCardView) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareToDeleteBankCard:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除此张银行卡吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self requestForDeleteCard:indexPath];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - <Net Request>
- (void)requestForBankCards {
    NAAPIModel *model = [NAURLCenter bankCardsConfig];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        
        NSLog(@"%@",returnValue);
        
        NSArray *dataArr = returnValue[@"data"];
        if (dataArr.count > 0) {
            [weakSelf.noBankCardView removeFromSuperview];
            
            [weakSelf.bankCardArr removeAllObjects];
            [weakSelf.bankCardArr addObjectsFromArray:dataArr];
            [weakSelf.tableView reloadData];
        } else if (![weakSelf isNoBankCardViewOn]) {
            [weakSelf.view addSubview:weakSelf.noBankCardView];
        }
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

- (void)requestForDeleteCard:(NSIndexPath *)indexPath {
    NABankCardModel *cardModel = [NABankCardModel yy_modelWithJSON:self.bankCardArr[indexPath.row]];
    NAAPIModel *model = [NAURLCenter deleteBankCardConfigWithCardId:cardModel.cardid];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [weakSelf.bankCardArr removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        if (weakSelf.bankCardArr.count <= 0 && ![weakSelf isNoBankCardViewOn]) {
            [weakSelf.view addSubview:weakSelf.noBankCardView];
        }
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

#pragma mark - <Events>
- (void)onAddBankCardClicked:(id)sender {
    if ([NAAuthenticationModel sharedModel].idcard == NAAuthenticationStateNot || [NAAuthenticationModel sharedModel].idcard == NAAuthenticationStateOverdue) {
        [SVProgressHUD showErrorWithStatus:@"请先进行身份认证"];
    } else {
        [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter addBankCardController] tranformStyle:NATransformStylePush needLogin:NO];
    }
}

- (void)onCellLongPressed:(UILongPressGestureRecognizer *)longPressGes {
    CGPoint point = [longPressGes locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    [self prepareToDeleteBankCard:indexPath];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankCardArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 127;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NABankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kBankCardCell forIndexPath:indexPath];
    
    NABankCardModel *model = [NABankCardModel yy_modelWithJSON:self.bankCardArr[indexPath.row]];
    cell.bankCardModel = model;
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onCellLongPressed:)];
    [cell addGestureRecognizer:longPressGes];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self prepareToDeleteBankCard:indexPath];
}

@end
