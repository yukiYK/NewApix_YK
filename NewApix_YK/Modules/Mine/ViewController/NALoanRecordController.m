//
//  NALoanRecordController.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/30.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NALoanRecordController.h"
#import "NALoanRecordModel.h"
#import "NALoanRecordCell.h"

static NSString * const kLoanRecordCellID = @"loanRecordCell";
static NSString * const kLoanRecordCellName = @"NALoanRecordCell";

@interface NALoanRecordController () <UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation NALoanRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customTitleLabel.text = @"贷款记录";
    [self setupTableView];
    if (!self.loanArray) [self requestForLoanList];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:kLoanRecordCellName bundle:nil] forCellReuseIdentifier:kLoanRecordCellID];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)requestForLoanList {
    NAAPIModel *model = [NAURLCenter mineLoanListConfig];
    
    WeakSelf
    [self.netManager GET:[NAURLCenter urlWithType:model.requestUrlType pathArray:model.pathArr] parameters:model.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSString *codeorNot = [NSString stringWithFormat:@"%@",responseObject];
        if ([codeorNot rangeOfString:@"code"].location != NSNotFound) {
            weakSelf.loanArray = nil;
        } else {
            weakSelf.loanArray = responseObject;
            [weakSelf.tableView reloadData];
        }
    } failure:nil];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loanArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 154.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NALoanRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kLoanRecordCellID forIndexPath:indexPath];
    NALoanRecordModel *loanModel = [NALoanRecordModel modelWithLoanDic:self.loanArray[indexPath.row]];
    cell.loanModel = loanModel;
    return cell;
}


@end
