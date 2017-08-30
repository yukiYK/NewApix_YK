//
//  NAForgetPasswordController.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/25.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAForgetPasswordController.h"
#import <AESCrypt.h>

@interface NAForgetPasswordController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *smsImgView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getSmsBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordVisibleBtn;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation NAForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavigationBar];
    [self addTextFieldTarget];
}



#pragma mark - <Private Method>
- (void)setupNavigationBar {
    self.customTitleLabel.text = @"忘记密码";
}

- (void)addTextFieldTarget {
    [self.smsTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)isPhoneNumber:(NSString *)phoneNumber {
    NSString *phone = @"^1[3-9]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    
    return [predicate evaluateWithObject:phoneNumber];
}

- (BOOL)isPassword:(NSString *)password {
    NSString *str = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    
    return [predicate evaluateWithObject:password];
}

- (void)startSmsTime {
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [self.getSmsBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.getSmsBtn.enabled = YES;
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.1];
                [self.getSmsBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.getSmsBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - <NetRequest>
- (void)requestForResetPassword {
    NSString *password = [AESCrypt encrypt:self.passwordTextField.text password:kAESKey];
    NAAPIModel *model = [NAURLCenter resetPasswordConfigWithPhone:self.phoneTextField.text password:password sms:self.smsTextField.text];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NAUserTool getDeviceId] forHTTPHeaderField:@"deviceid"];
    [manager.requestSerializer setValue:[NAUserTool getSystemVersion] forHTTPHeaderField:@"systemversion"];
    [manager.requestSerializer setValue:[NAUserTool getEquipmentType] forHTTPHeaderField:@"equipmenttype"];
    
    WeakSelf
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        [SVProgressHUD showSuccessWithStatus:@"密码重置成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_MSEC * 500)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        if ([code isEqualToString:@"-1"]) {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"重置密码失败"];
        }
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

- (void)requestForGetSms {
    NAAPIModel *model = [NAURLCenter getSmsConfigForResetPasswordWithPhoneNumber:self.phoneTextField.text];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [weakSelf startSmsTime];
        [SVProgressHUD showWithStatus:@"验证码已发送"];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

#pragma mark - <Events>
- (IBAction)onGetSmsBtnClicked:(id)sender {
    if ([self isPhoneNumber:self.phoneTextField.text]) {
        [self requestForGetSms];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
    }
}

- (IBAction)onPasswordVisibleBtnClicked:(id)sender {
    self.passwordVisibleBtn.selected = !self.passwordVisibleBtn.selected;
    
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
}

- (IBAction)onSubmitBtnClicked:(id)sender {
    if ([self isPassword:self.passwordTextField.text]) {
        [self requestForResetPassword];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"密码必须是6-20位字母数字组合"];
    }
}

-(void)textFieldDidValueChanged:(UITextField *)textField {
    if (self.phoneTextField.text.length > 0 && self.smsTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.submitBtn.enabled = YES;
        [self.submitBtn setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
    }
    else {
        self.submitBtn.enabled = NO;
        [self.submitBtn setBackgroundImage:kGetImage(@"login_btn_gray") forState:UIControlStateNormal];
    }
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
        self.smsImgView.image = kGetImage(@"register_sms");
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
        self.smsImgView.image = kGetImage(@"register_sms_gray");
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.smsTextField resignFirstResponder];
}

@end
