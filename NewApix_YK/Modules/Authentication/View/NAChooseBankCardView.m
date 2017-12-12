//
//  NAChooseBankCardView.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/12/1.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAChooseBankCardView.h"
#import "NAChooseBankCardCell.h"
#import "NABankCardModel.h"

static NSString * const kChooseBankCardCellName = @"NAChooseBankCardCell";
static NSString * const kChooseBankCardCellID = @"chooseBankCardCell";

@interface NAChooseBankCardView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cardArr;

@property (nonatomic, assign) NSInteger selectedRow;

@end


@implementation NAChooseBankCardView

- (instancetype)initWithBankCardArr:(NSArray *)cardArr {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGes];
        
        self.selectedRow = -1;
        self.cardArr = cardArr;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight/2)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [self tableFooterView];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerNib:[UINib nibWithNibName:kChooseBankCardCellName bundle:nil] forCellReuseIdentifier:kChooseBankCardCellID];
    [self addSubview:tableView];
    self.tableView = tableView;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    [addBtn addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, kScreenWidth, 1)];
    line.backgroundColor = kColorGraySeperator;
    [footerView addSubview:line];
    
    UILabel *bankCard = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 120, 15)];
    bankCard.text = @"添加收款银行卡";
    bankCard.textAlignment = NSTextAlignmentLeft;
    bankCard.font = [UIFont systemFontOfSize:16];
    [footerView addSubview:bankCard];
    
    UIImageView *addImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-45, 15, 20, 20)];
    addImg.image = kGetImage(@"bank_add");
    [footerView addSubview:addImg];
    
    return footerView;
}

- (void)resetWithCardArr:(NSArray *)cardArr {
    self.cardArr = cardArr;
    [self.tableView reloadData];
}

- (void)addBankCard {
    if (self.addCardBlock)
        self.addCardBlock();
    [self dismiss];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, kScreenHeight/2, self.tableView.width, self.tableView.height);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, kScreenHeight, self.tableView.width, self.tableView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NAChooseBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kChooseBankCardCellID forIndexPath:indexPath];
    NABankCardModel *model = [NABankCardModel yy_modelWithJSON:self.cardArr[indexPath.row]];
    cell.cardModel = model;
    if (self.selectedRow == indexPath.row)
        cell.isChosen = YES;
    else cell.isChosen = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedRow = indexPath.row;
    [self.tableView reloadData];
    
    NABankCardModel *model = [NABankCardModel yy_modelWithJSON:self.cardArr[indexPath.row]];
    if (self.chooseBlock)
        self.chooseBlock(model);
    [self dismiss];
}

@end
