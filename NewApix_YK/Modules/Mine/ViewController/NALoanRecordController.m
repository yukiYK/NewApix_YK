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
    if (!self.loanArray || self.loanArray.count <= 0)
        tableView.tableFooterView = [self tableFooterView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.tableView.height)];
    UIImageView *nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.47, kScreenHeight * 0.23)];
    nullImageView.center = footer.center;
    nullImageView.y -= 50;
    nullImageView.image = kGetImage(@"loan_record_empty");
    [footer addSubview:nullImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nullImageView.frame) + 25, kScreenWidth, 20)];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorFromString:@"dadada"];
    label.text = @"暂无记录";
    [footer addSubview:label];
    
    return footer;
}

- (void)requestForLoanList {
    NAAPIModel *model = [NAURLCenter mineLoanListConfig];
    
    WeakSelf
    [self.netManager GET:[NAURLCenter urlWithType:model.requestUrlType pathArray:model.pathArr] parameters:model.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSString *codeorNot = [NSString stringWithFormat:@"%@",responseObject];
        if ([codeorNot rangeOfString:@"code"].location != NSNotFound) {
            weakSelf.loanArray = nil;
            weakSelf.tableView.tableFooterView = [weakSelf tableFooterView];
        } else {
            weakSelf.loanArray = responseObject;
            weakSelf.tableView.tableFooterView = [[UIView alloc] init];
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
