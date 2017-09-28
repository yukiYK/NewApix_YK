//
//  NALoginController.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NALoginController.h"
#import "NATabbarController.h"
#import <AESCrypt.h>

@interface NALoginController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImgView;


@property (weak, nonatomic) IBOutlet UIButton *passwordVisibleBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation NALoginController

#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavigationBar];
    
    [self setupSubviews];
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
- (void)setupSubviews {
    [self.phoneTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.phoneTextField.text = [defaults objectForKey:kUserDefaultsIdNumber];
    self.passwordTextField.text = [NAKeyChain loadKeyChainWithKey:kKeyChainPassword];
    
    [self checkLoginEnable];
}

- (void)checkLoginEnable {
    
    if (self.phoneTextField.text.length > 0 && self.passwordTextField.text.length > 0){
        self.loginBtn.enabled = YES;
        [self.loginBtn setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
    }
    else {
        self.loginBtn.enabled = NO;
        [self.loginBtn setBackgroundImage:kGetImage(@"login_btn_gray") forState:UIControlStateNormal];
    }
}

#pragma mark - <Network>
- (void)requestForLogin {
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    NSString *password = [AESCrypt encrypt:self.passwordTextField.text password:kAESKey];
    NAAPIModel *model = [NAURLCenter loginConfigWithPhone:self.phoneTextField.text password:password];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    [manager setRequestSerializerForPost];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        NSDictionary *dataDic = [returnValue objectForKey:@"data"];
        NSString *token = [dataDic objectForKey:@"token"];
        NSString *uniqueId = [AESCrypt decrypt:[dataDic objectForKey:@"unique_id"] password:kAESKey];
        [NACommon setToken:token];
        [NACommon setUniqueId:uniqueId];
        
        // 重新获取用户状态
        [NACommon loadUserStatusComplete:^(NAUserStatus userStatus) {
            // 获取用户信用分数
            [self requestForTrustScore];
        }];
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:@"您输入的账号或密码有误"];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

- (void)requestForTrustScore {
    NAAPIModel *model = [NAURLCenter trustScoreConfig];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [NAUserTool saveTrustSocre:returnValue[@"score"]];
        // 重新设置根视图
        NATabbarController *tabbarC = [[NATabbarController alloc] init];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].keyWindow.rootViewController = tabbarC;
        });
        
        [SVProgressHUD dismiss];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        [SVProgressHUD dismiss];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - <Events>
- (void)onRegisterBtnClicked:(UIButton *)button {
    UIViewController *toVC = [NAViewControllerCenter registerController];
    [NAViewControllerCenter transformViewController:self toViewController:toVC tranformStyle:NATransformStylePush needLogin:NO];
}

- (void)onBackBtnClicked:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onForgetPasswordClicked:(id)sender {
    [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter forgetPasswordController] tranformStyle:NATransformStylePush needLogin:NO];
}

- (IBAction)onPhoneLoginClicked:(id)sender {
    [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter phoneLoginController] tranformStyle:NATransformStylePush needLogin:NO];
}

- (IBAction)onPasswordVisibleClicked:(id)sender {
    self.passwordVisibleBtn.selected = !self.passwordVisibleBtn.selected;
    
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
}

- (IBAction)onLoginBtnClicked:(id)sender {
    [self requestForLogin];
}

- (void)textFieldValueChanged:(UITextField *)textField {
    [self checkLoginEnable];
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        self.phoneImgView.image = kGetImage(@"login_user");
    }
    else if (textField == self.passwordTextField) {
        self.passwordImgView.image = kGetImage(@"login_password");
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        self.phoneImgView.image = kGetImage(@"login_user_gray");
    }
    else if (textField == self.passwordTextField) {
        self.passwordImgView.image = kGetImage(@"login_password_gray");
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end
