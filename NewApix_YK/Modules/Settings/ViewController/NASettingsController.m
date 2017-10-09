//
//  NASettingsController.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/26.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NASettingsController.h"
#import <Masonry.h>
#import "NAAuthenticationModel.h"

@interface NASettingsController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UITableView *tableView;

// 一些固定数据
@property (nonatomic, strong) NSArray *dataArray2;
@property (nonatomic, strong) NSArray *jobsArray;
@property (nonatomic, strong) NSArray *masterArray;
@property (nonatomic, strong) NSArray *marriageArray;

// 个人设置的数据
@property (nonatomic, strong) NSData *avatarData;
@property (nonatomic, assign) BOOL isAddressExist;
@property (nonatomic, assign) BOOL isIdCardAuthentication;
@property (nonatomic, copy) NSString *idCardNumber;
@property (nonatomic, copy) NSString *bankCardNumber;

@end

@implementation NASettingsController
#pragma mark - <Lazy Load>
- (NSArray *)dataArray2 {
    if (!_dataArray2) {
        _dataArray2 = [NSArray arrayWithObjects:@"修改手机号", @"修改登录密码", @"常见问题", @"关于我们", nil];
    }
    return _dataArray2;
}

- (NSArray *)jobsArray {
    if (!_jobsArray) {
        _jobsArray = [NSArray arrayWithObjects:@"上班族", @"学生", @"自由工作者", @"企业主", nil];
    }
    return _jobsArray;
}

- (NSArray *)masterArray {
    if (!_masterArray) {
        _masterArray = [NSArray arrayWithObjects:@"硕士及以上", @"本科", @"专科", @"高中及以下", nil];
    }
    return _masterArray;
}

- (NSArray *)marriageArray {
    if (!_marriageArray) {
        _marriageArray = [NSArray arrayWithObjects:@"未婚", @"已婚且无子女", @"已婚且有子女", @"离异", @"丧偶", nil];
    }
    return _marriageArray;
}

#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorHeaderGray;
    
    
    [self setupNavigation];
    [self setupTableView];
    [self requestForAuthentication];
}

#pragma mark - <Private Method>
- (void)setupNavigation {
    self.customTitleLabel.text = @"个人中心";
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 50, 50);
    right.titleLabel.font = [UIFont systemFontOfSize:14];
    [right addTarget:self action:@selector(onSaveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [right setTitle:@"保存" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBut;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.backgroundColor = kColorHeaderGray;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [self tableHeaderView];
    tableView.tableFooterView = [self tableFooterView];
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
    avatarImgView.userInteractionEnabled = YES;
    avatarImgView.image =kGetImage(kImageAvatarDefault);
    [headerView addSubview:avatarImgView];
    [avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-16);
        make.centerY.equalTo(headerView.mas_centerY);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    self.avatarImgView = avatarImgView;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar)];
    [headerView addGestureRecognizer:tapGes];
    
    return headerView;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:kColorTextBlack forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(onExitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left);
        make.right.equalTo(footerView.mas_right);
        make.top.equalTo(footerView.mas_top).offset(10);
        make.bottom.equalTo(footerView.mas_bottom);
    }];
    
    return footerView;
}

- (void)setTableViewCell:(UITableViewCell *)cell withTitle:(NSString *)title detailTitle:(NSString *)detailTitle showRightArrow:(BOOL)showRightArrow {
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detailTitle;
    if (showRightArrow) cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)showChangeNickAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入您的昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"昵称";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *nickTF = alert.textFields.firstObject;
        self.userInfoModel.nick_name = nickTF.text;
        [self.tableView reloadData];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 解析认证状态
- (void)analysisAuthentication:(NSDictionary *)returnValue {
    NAAuthenticationModel *model = [NAAuthenticationModel yy_modelWithJSON:returnValue[@"data"]];
    
    NSArray *reset_data = returnValue[@"reset_data"];
    NSArray *update_prompt = returnValue[@"update_prompt"];
    NSArray *propertyArray = [NAAuthenticationModel getAllProperties];
    if (reset_data.count > 0) {
        [reset_data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:@"carrier"]) {
                    model.isp = NAAuthenticationStateOverdue;
                }
                else if ([key isEqualToString:@"identity"]) {
                    model.idcard = NAAuthenticationStateOverdue;
                }
                else if ([propertyArray containsObject:key]) {
                    id propertyValue = [[[NSNumberFormatter alloc] init] numberFromString:@"2"];
                    [model setValue:propertyValue forKey:key];
                }
            }];
        }];
    }
    if (update_prompt.count > 0) {
        [update_prompt enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            for (NSString *key in dict.allKeys) {
                NSString *value = [NSString stringWithFormat:@"%@", [dict objectForKey:key]];
                
                id propertyValue = [[[NSNumberFormatter alloc] init] numberFromString:@"4"];
                if ([value integerValue] == 1)
                    propertyValue = [[[NSNumberFormatter alloc] init] numberFromString:@"3"];
                
                if ([key isEqualToString:@"carrier"]) {
                    [model setValue:propertyValue forKey:@"isp"];
                }
                else if ([key isEqualToString:@"identity"]) {
                    [model setValue:propertyValue forKey:@"idcard"];
                }
                else if ([propertyArray containsObject:key]) {
                    id propertyValue = [[[NSNumberFormatter alloc] init] numberFromString:@"3"];
                    [model setValue:propertyValue forKey:key];
                }
            }
        }];
    }
}

- (void)pickPhotoFromAlbum {
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    pickerC.allowsEditing = YES;
    pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerC animated:YES completion:nil];
}

- (void)takePhoto {
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    pickerC.allowsEditing = YES;
    pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerC animated:YES completion:nil];
}

#pragma mark - <Events>
- (void)onExitBtnClicked:(UIButton *)button {
    
}

- (void)onSaveBtnClicked:(UIButton *)button {
    [self requestForUpdateUserInfo];
}

- (void)changeAvatar {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择修改头像方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *pickPhotoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickPhotoFromAlbum];
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    [alert addAction:cancelAction];
    [alert addAction:pickPhotoAction];
    [alert addAction:takePhotoAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - <Net Request>
- (void)requestForAuthentication {
    NAAPIModel *model = [NAURLCenter authenticationConfig];
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        [self analysisAuthentication:returnValue];
        [self.tableView reloadData];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)requestForAddress {
    NAAPIModel *model = [NAURLCenter userAddressConfig];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        
        NSArray *addressArr = returnValue[@"address"];
        if (addressArr.count <= 0) self.isAddressExist = NO;
        else self.isAddressExist = YES;
        
        [self.tableView reloadData];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)requestForUpdateUserInfo {
    
    // 图片名
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", timeInterval];
    NSString *fileName = [NSString stringWithFormat:@"%@userIcon.png",timeString];
    
    NAAPIModel *model = [NAURLCenter updateUserInfoConfigWithModel:self.userInfoModel];
    NSString *urlStr = [NAURLCenter urlWithType:NARequestURLTypeAPI pathArray:model.pathArr];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    [manager setRequestSerializerForPost];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager netRequesPOSTWithRequestURL:urlStr parameter:model.param constructingBodyBlock:^(id<AFMultipartFormData> formData) {
        if (self.avatarData)
            [formData appendPartWithFileData:self.avatarData name:@"avatar" fileName:fileName mimeType:@"image/png"];
    } progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，保存失败"];
    }];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumber = 0;
    if (section == 0) rowNumber = 5;
    else if (section == 1) rowNumber = 4;
    return rowNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingsCell"];
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = kColorTextLightGray;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = kColorTextBlack;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self setTableViewCell:cell withTitle:@"账号" detailTitle:self.userInfoModel.phone_number showRightArrow:NO];
        } else if (indexPath.row == 1) {
            [self setTableViewCell:cell withTitle:@"昵称" detailTitle:self.userInfoModel.nick_name showRightArrow:YES];
        } else if (indexPath.row == 2) {
            [self setTableViewCell:cell withTitle:@"实名认证" detailTitle:@"" showRightArrow:YES];
            if (!self.isIdCardAuthentication) {
                cell.detailTextLabel.text = @"点击完成身份认证";
                cell.detailTextLabel.textColor = kColorLightBlue;
            }
        } else if (indexPath.row == 3) {
            [self setTableViewCell:cell withTitle:@"银行卡管理" detailTitle:@"" showRightArrow:YES];
        } else if (indexPath.row == 4) {
            [self setTableViewCell:cell withTitle:@"收货地址" detailTitle:@"" showRightArrow:YES];
            if (!self.isAddressExist && self.isVipForever) {
                
                UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 10/11 + 1, cell.contentView.bounds.size.height/2 - 3, 6, 6)];
                redView.layer.masksToBounds = YES;
                redView.layer.cornerRadius = 3;
                redView.backgroundColor = [UIColor redColor];
                [cell.contentView addSubview:redView];
                cell.detailTextLabel.text = @"请填写会员礼包派送地址";
            }
        }
    } else if (indexPath.section == 1) {
        NSString *title = self.dataArray2[indexPath.row];
        [self setTableViewCell:cell withTitle:title detailTitle:@"" showRightArrow:YES];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {    // 昵称
            [self showChangeNickAlert];
        } else if (indexPath.row == 2) { // 实名认证
            
        } else if (indexPath.row == 3) { // 银行卡管理
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter bankCardsController]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:NO];
        } else if (indexPath.row == 4) {  // 收货地址
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter addressController]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:YES];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {  // 修改手机号
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter changePhoneController]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:NO];
        } else if (indexPath.row == 1) {  // 修改登录密码
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter changePasswordController]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:NO];
        } else if (indexPath.row == 2) {  // 常见问题
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter commonQuestionsController]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:NO];
        } else if (indexPath.row == 3) {  // 关于我们
            [NAViewControllerCenter transformViewController:self
                                           toViewController:[NAViewControllerCenter aboutUsController]
                                              tranformStyle:NATransformStylePush
                                                  needLogin:NO];
        }
    }
}

#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image =info[@"UIImagePickerControllerEditedImage"];
    self.avatarImgView.image = image;
    // 图片data
    UIImage *avatar = [image imageCompresstoMaxFileSize:1024 * 1024 * 2];
    self.avatarData = UIImageJPEGRepresentation(avatar, 1.0);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
