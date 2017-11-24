//
//  NAVideoVIPListController.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/11/23.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAVideoVIPListController.h"
#import "NAVideoVIPListCell.h"

static NSString * const kVideoVIPListCellName = @"NAVideoVIPListCell";
static NSString * const kVideoVIPListCellID = @"videoVIPListCell";

@interface NAVideoVIPListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *videoCardArr;

@end

@implementation NAVideoVIPListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
    [self requestForVideoVIPList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
}

- (void)setupNavigation {
    self.customTitleLabel.text = @"视频会员";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = kColorGraySeperator;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:kVideoVIPListCellName bundle:nil] forCellReuseIdentifier:kVideoVIPListCellID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - <Net Request>
- (void)requestForVideoVIPList {
    NAAPIModel *model = [NAURLCenter videoVIPListConfig];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        weakSelf.videoCardArr = returnValue[@"products"] ? returnValue[@"products"] : [NSArray array];
        if (weakSelf.videoCardArr.count > 0)
            [weakSelf.tableView reloadData];
        
    } errorCodeBlock:nil failureBlock:nil];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoCardArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenWidth * 0.24 + 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NAVideoVIPListCell *cell = [tableView dequeueReusableCellWithIdentifier:kVideoVIPListCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NAGoodsModel *goodsModel = [NAGoodsModel yy_modelWithJSON:self.videoCardArr[indexPath.row]];
    cell.goodsModel = goodsModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NAGoodsModel *goodsModel = [NAGoodsModel yy_modelWithJSON:self.videoCardArr[indexPath.row]];
    UIViewController *toVC = [NAViewControllerCenter goodsDetailControllerWithModel:goodsModel];
    [NAViewControllerCenter transformViewController:self toViewController:toVC tranformStyle:NATransformStylePush needLogin:NO];
}


@end
