//
//  NAPresentCenterController.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/11.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAPresentCenterController.h"
#import "NAAddressModel.h"
#import "NAPresentSuccessController.h"
#import "NAMeixinVIPController.h"
#import "UINavigationController+NAStatusBar.h"

@interface NAPresentCenterController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *receivePresentBtn;

@property (weak, nonatomic) IBOutlet UIView *detailInfoView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *changeAddressBtn;

@property (nonatomic, strong) NAAddressModel *addressModel;

@end

@implementation NAPresentCenterController
#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupInfoView];
    [self requestForBgImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigation];
    [self requestForAddress];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorFromString:@"f2f2f2"]]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - <Private Method>
- (void)setupNavigation {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.customTitleLabel.text = @"礼品中心";
    self.customTitleLabel.textColor = [UIColor whiteColor];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 20, 30)];
    [left addTarget:self action:@selector(onBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [left setImage:kGetImage(kImageBackWhite) forState:UIControlStateNormal];
    [left setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBut;
}

- (void)setupInfoView {
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont systemFontOfSize:13];
    addressLabel.textColor = [UIColor colorFromString:@"d3b27d"];
    addressLabel.text = @"详细地址：这是地址这是地址这是地址这是地址这是地址这是地址这是地址这是地址这是地址这是地址这是地址这是地址";
    addressLabel.numberOfLines = 0;
    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.detailInfoView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.detailInfoView.mas_bottom);
        make.left.equalTo(self.detailInfoView.mas_left);
        make.right.equalTo(self.detailInfoView.mas_right);
    }];
    self.addressLabel = addressLabel;
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.font = [UIFont systemFontOfSize:13];
    phoneLabel.textColor = [UIColor colorFromString:@"d3b27d"];
    phoneLabel.text = @"联系电话：12345678900";
    phoneLabel.numberOfLines = 1;
    [self.detailInfoView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.addressLabel.mas_top);
        make.left.equalTo(self.detailInfoView.mas_left);
        make.right.equalTo(self.detailInfoView.mas_right);
    }];
    self.phoneLabel = phoneLabel;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = [UIColor colorFromString:@"d3b27d"];
    nameLabel.text = @"领奖人：姓名";
    nameLabel.numberOfLines = 1;
    [self.detailInfoView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.phoneLabel.mas_top);
        make.left.equalTo(self.detailInfoView.mas_left);
        make.right.equalTo(self.detailInfoView.mas_right);
    }];
    self.nameLabel = nameLabel;
    
    UIButton *changeAddressBtn = [[UIButton alloc] init];
    [changeAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeAddressBtn setBackgroundColor:[UIColor colorFromString:@"d3b27d"]];
    [changeAddressBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [changeAddressBtn setTitle:@"修改地址" forState:UIControlStateNormal];
    [changeAddressBtn addTarget:self action:@selector(onChangeAddressBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    changeAddressBtn.layer.cornerRadius = 9;
    changeAddressBtn.layer.masksToBounds = YES;
    [self.detailInfoView addSubview:changeAddressBtn];
    [changeAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.detailInfoView.mas_right);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(18);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    self.changeAddressBtn = changeAddressBtn;
}

- (void)resetInfoViewWithAddress:(NAAddressModel *)model {
    
    if (model) {
        self.detailInfoView.hidden = NO;
        
        self.nameLabel.text = [NSString stringWithFormat:@"领奖人：%@", model.receiver];
        self.phoneLabel.text = [NSString stringWithFormat:@"联系电话：%@", model.receiver_phone];
        self.addressLabel.text = [NSString stringWithFormat:@"详细地址：%@%@%@%@",model.province, model.city, model.district, model.address];
    }
    else {
        self.detailInfoView.hidden = YES;
    }
}

#pragma mark - <Net Request>
- (void)requestForAddress {
    
    NAAPIModel *model = [NAURLCenter userAddressConfig];
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        NSString *code = [NSString stringWithFormat:@"%@", returnValue[@"code"]];
        NSArray *addressArr = returnValue[@"address"];
        if (addressArr && addressArr.count > 0 && [code isEqualToString:@"0"]) {
            NSDictionary *dic = addressArr[0];
            NAAddressModel *addressModel = [NAAddressModel yy_modelWithJSON:dic];
            
            [weakSelf resetInfoViewWithAddress:addressModel];
            self.addressModel = addressModel;
        }
        else {
            [weakSelf resetInfoViewWithAddress:nil];
            self.addressModel = nil;
        }
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        NSLog(@"code = %@", code);
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)requestForBgImage {
    
    NAAPIModel *model = [NAURLCenter presentCenterBgConfig];
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@", returnValue[@"img"]];
        [weakSelf.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)requestForReceivePresent {
    
    NAAPIModel *model = [NAURLCenter receivePresentConfig];
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        NSString *code = [NSString stringWithFormat:@"%@", returnValue[@"code"]];
        
        //        PresentSuccessController *presentSuccessVC = [[PresentSuccessController alloc] initWithNibName:@"PresentSuccessController" bundle:nil];
        //        [weakSelf.navigationController pushViewController:presentSuccessVC animated:YES];
        
        if ([code isEqualToString:@"2"]) {
            [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter presentSuccessController] tranformStyle:NATransformStylePush needLogin:NO];
        }
        else if ([code isEqualToString:@"1"]) {
            [SVProgressHUD showErrorWithStatus:@"已经领取过了"];
        }
        else if ([code isEqualToString:@"-1"] || [code isEqualToString:@"-2"]) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"领取失败" message:@"只有终身会员才有领取权限哦~" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *buyVipAction = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIViewController *vipC = [NAViewControllerCenter meixinVIPControllerWithIsFromGiftCenter:YES];
                [NAViewControllerCenter transformViewController:self toViewController:vipC tranformStyle:NATransformStylePush needLogin:NO];
            }];
            [alertC addAction:cancelAction];
            [alertC addAction:buyVipAction];
            [weakSelf presentViewController:alertC animated:YES completion:nil];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"领取失败"];
        }
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}


#pragma mark - <Events>
- (void)onBackClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onReceivePresentBtnClicked:(id)sender {
    
    if (!_addressModel) {
        [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter addressController] tranformStyle:NATransformStylePush needLogin:NO];
    }
    else {
        [self requestForReceivePresent];
    }
}

- (void)onChangeAddressBtnClicked:(UIButton *)button {
    [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter addressController] tranformStyle:NATransformStylePush needLogin:NO];
}

@end
