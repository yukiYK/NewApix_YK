//
//  NASettingsController.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/26.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NASettingsController.h"
#import <Masonry.h>

@interface NASettingsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation NASettingsController
#pragma mark - <Lazy Load>
- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray arrayWithObjects:@"", nil];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorHeaderGray;
    
    [self setupNavigation];
    [self setupTableView];
}

- (void)setupNavigation {
    
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.top.equalTo(self.view.mas_top);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
    self.tableView = tableView;
}

- (UIView *)tableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = kColorTextBlack;
    label.text = @"头像";
    label.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(16);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    
    UIImageView *avatarImgView = [[UIImageView alloc] init];
    avatarImgView.image =kGetImage(kImageAvatarDefault);
    [headerView addSubview:avatarImgView];
    [avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-16);
        make.centerY.equalTo(headerView.mas_centerY);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    self.avatarImgView = avatarImgView;
    
    return headerView;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:kColorTextBlack forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(onExitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left);
        make.right.equalTo(footerView.mas_right);
        make.top.equalTo(footerView.mas_top);
        make.bottom.equalTo(footerView.mas_bottom);
    }];
    
    return footerView;
}

- (void)setTableViewCell:(UITableViewCell *)cell withTitle:(NSString *)title detailTitle:(NSString *)detailTitle showRightArrow:(BOOL)showRightArrow {
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detailTitle;
    if (showRightArrow) cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)onExitBtnClicked:(UIButton *)button {
    
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingsCell"];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self setTableViewCell:cell withTitle:@"账号" detailTitle:@"" showRightArrow:NO];
        }
    }
    else if (indexPath.section == 1) {
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
@end
