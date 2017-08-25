//
//  NARegisterController.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NARegisterController.h"

@interface NARegisterController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UITextField *imageSmsTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *smsImgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSmsImgView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImgView;

@property (weak, nonatomic) IBOutlet UIImageView *bigImgSmsImgView;

@property (weak, nonatomic) IBOutlet UIButton *getSmsBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordVisibleBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


@end

@implementation NARegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavigationBar];
}

#pragma mark - <Private Method>
- (void)setupNavigationBar {
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 50, 50);
    right.titleLabel.font = [UIFont systemFontOfSize:15];
    [right addTarget:self action:@selector(onRegisterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [right setTitle:@"注册" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBut;
    
    self.customTitleLabel.text = @"登录";
    
    self.hidesBottomBarWhenPushed=YES;
    
}

#pragma mark - <Events>
- (IBAction)onPasswordVisibleClicked:(id)sender {
}

- (IBAction)onGetSmsClicked:(id)sender {
}

- (IBAction)onUserProtocolClicked:(id)sender {
}

- (IBAction)onAgreeClicked:(id)sender {
}

- (IBAction)onRegisterBtnClicked:(id)sender {
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        self.phoneImgView.image = kGetImage(@"login_user");
    }
    else if (textField == self.passwordTextField) {
        self.passwordImgView.image = kGetImage(@"login_password");
    }
    else if (textField == self.smsTextField) {
        self.passwordImgView.image = kGetImage(@"login_sms");
    }
    else if (textField == self.imageSmsTextField) {
        self.passwordImgView.image = kGetImage(@"login_imgSms");
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        self.phoneImgView.image = kGetImage(@"login_user_gray");
    }
    else if (textField == self.passwordTextField) {
        self.passwordImgView.image = kGetImage(@"login_password_gray");
    }
    else if (textField == self.smsTextField) {
        self.passwordImgView.image = kGetImage(@"login_sms_gray");
    }
    else if (textField == self.imageSmsTextField) {
        self.passwordImgView.image = kGetImage(@"login_imgSms_gray");
    }
}

@end
