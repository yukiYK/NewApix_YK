//
//  NARegisterController.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NARegisterController.h"
#import <AESCrypt.h>
#import "NATabbarController.h"

@interface NARegisterController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

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

@property (nonatomic, copy) NSString *imgSmsKey;

@end

@implementation NARegisterController
#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavigationBar];
    [self addTextFieldTarget];
    [self requestForImgSms];
}

#pragma mark - <Private Method>
- (void)setupNavigationBar {
    
    self.customTitleLabel.text = @"登录";
}

- (void)addTextFieldTarget {
    [self.smsTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.imageSmsTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
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
- (void)requestForGetSms {
    NAAPIModel *model = [NAURLCenter getSmsConfigForRegisterWithPhoneNumber:self.phoneTextField.text];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [weakSelf startSmsTime];
        [SVProgressHUD showWithStatus:@"验证码已发送"];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        if ([code isEqualToString:@"-3"]) {
            [SVProgressHUD showErrorWithStatus:@"该手机号已经注册过了"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
        }
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

- (void)requestForImgSms {
    NAAPIModel *model = [NAURLCenter getImgSmsConfig];
    NSString *urlStr = [NAURLCenter urlWithType:NARequestURLTypeAPI pathArray:model.pathArr];
    WeakSelf
    [self.netManager GET:urlStr parameters:model.param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *returnValue = responseObject;
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS_API, returnValue[@"url"]];
        [weakSelf.bigImgSmsImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        
        weakSelf.imgSmsKey = [NSString stringWithFormat:@"%@", returnValue[@"key"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)requestForRegister {
    [SVProgressHUD showWithStatus:@"注册中..."];
    NSString *password = [AESCrypt encrypt:self.passwordTextField.text password:kAESKey];
    NAAPIModel *model = [NAURLCenter registerConfigWithPhone:self.phoneTextField.text
                                                    password:password
                                                         sms:self.smsTextField.text
                                                      imgSms:self.imageSmsTextField.text
                                                   imgSmsKey:self.imgSmsKey];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        NSDictionary *dataDic = returnValue[@"data"];
        
        NSString *token = [dataDic objectForKey:@"token"];
        NSString *uniqueId = [dataDic objectForKey:@"unique_id"];
        [NACommon setToken:token];
        [NACommon setUniqueId:uniqueId];
        
        // 重新获取用户状态
        [NACommon loadUserStatusComplete:^(NAUserStatus userStatus) {
            // 获取用户信用分数
            [weakSelf requestForTrustScore];
        }];
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        if ([code isEqualToString:@"-1"]) {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"注册失败"];
        }
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

- (void)requestForTrustScore {
    NAAPIModel *model = [NAURLCenter trustScoreConfigWithToken:[NACommon getToken]];
    
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
- (IBAction)onPasswordVisibleClicked:(id)sender {
    self.passwordVisibleBtn.selected = !self.passwordVisibleBtn.selected;
    
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
}

- (IBAction)onGetSmsClicked:(id)sender {
    
    if ([self isPhoneNumber:self.phoneTextField.text]) {
        [self requestForGetSms];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
    }
}

- (IBAction)onUserProtocolClicked:(id)sender {
    UIViewController *toVC = [NAViewControllerCenter commonWebControllerWithCardModel:nil isShowShareBtn:NO];
    [NAViewControllerCenter transformViewController:self toViewController:toVC tranformStyle:NATransformStylePush needLogin:NO];
}

- (IBAction)onAgreeClicked:(id)sender {
    self.agreeBtn.selected = !self.agreeBtn.selected;
}

- (IBAction)onRegisterBtnClicked:(id)sender {
    if ([self isPassword:self.passwordTextField.text]) {
        [self requestForRegister];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"密码必须是6-20位字母数字组合"];
    }
}

-(void)textFieldDidValueChanged:(UITextField *)textField {
    if (self.phoneTextField.text.length > 0 && self.smsTextField.text.length > 0 &&
        self.imageSmsTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.registerBtn.enabled = YES;
        [self.registerBtn setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
    }
    else {
        self.registerBtn.enabled = NO;
        [self.registerBtn setBackgroundImage:kGetImage(@"login_btn_gray") forState:UIControlStateNormal];
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
    else if (textField == self.imageSmsTextField) {
        self.imgSmsImgView.image = kGetImage(@"register_imgSms");
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
    else if (textField == self.imageSmsTextField) {
        self.imgSmsImgView.image = kGetImage(@"register_imgSms_gray");
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.smsTextField resignFirstResponder];
    [self.imageSmsTextField resignFirstResponder];
}

@end
