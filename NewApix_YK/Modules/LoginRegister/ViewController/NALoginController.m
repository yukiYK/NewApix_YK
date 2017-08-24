//
//  NALoginController.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NALoginController.h"

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    titleLabel.text = @"登录";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self.navigationItem setTitleView:titleLabel];
    
    self.hidesBottomBarWhenPushed=YES;
    
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(-20, 0, 35, 35)];
    [left addTarget:self action:@selector(onBackBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [left setImage:kGetImage(kImageBackBlack) forState:UIControlStateNormal];
    [left setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //修改方法
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBut;
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - <Network>
- (void)requestForLogin {
    
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
}

- (IBAction)onPhoneLoginClicked:(id)sender {
}

- (IBAction)onPasswordVisibleClicked:(id)sender {
    self.passwordVisibleBtn.selected = !self.passwordVisibleBtn.selected;
    
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
}


- (IBAction)onLoginBtnClicked:(id)sender {
    
}

- (void)textFieldValueChanged:(UITextField *)textField {
    [self checkLoginEnable];
}
#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        self.phoneImgView.image = kGetImage(@"");
        
    }
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
