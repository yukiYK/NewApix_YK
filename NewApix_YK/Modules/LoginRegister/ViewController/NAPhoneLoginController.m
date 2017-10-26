//
//  NAPhoneLoginController.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/25.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAPhoneLoginController.h"
#import "NATabbarController.h"
#import <AESCrypt.h>

@interface NAPhoneLoginController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *smsImgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UIButton *getSmsBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation NAPhoneLoginController
#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavigationBar];
    [self addTextFieldTarget];
}

#pragma mark - <Private Method>
- (void)setupNavigationBar {
    self.customTitleLabel.text = @"手机登录";
}

- (void)addTextFieldTarget {
    [self.smsTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)isPhoneNumber:(NSString *)phoneNumber {
    NSString *phone = @"^1[3-9]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    
    return [predicate evaluateWithObject:phoneNumber];
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

#pragma mark - <Net Request>
- (void)requestForPhoneLogin {
    [SVProgressHUD showWithStatus:@"登录中..."];
    NAAPIModel *model = [NAURLCenter phoneLoginConfigWithPhone:self.phoneTextField.text sms:self.smsTextField.text];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSDictionary *dataDic = [returnValue objectForKey:@"data"];
        NSString *token = [dataDic objectForKey:@"token"];
        NSString *uniqueId = [AESCrypt decrypt:[dataDic objectForKey:@"unique_id"] password:kAESKey];
        [NACommon setToken:token];
        [NACommon setUniqueId:uniqueId];
        
        // 重新获取用户状态
        [NACommon loadUserStatusComplete:^(NAUserStatus userStatus, NSString *vipEndDate, NSString *vipSkin) {
            // 获取用户信用分数
            [self requestForTrustScore];
        }];
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        // 这里code=1也是登录成功。。。
        if ([code isEqualToString:@"1"]) {
            
        }
        else if ([code isEqualToString:@"-1"]) {
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
        else if ([code isEqualToString:@"-2"]) {
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
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

- (void)requestForGetSms {
    NAAPIModel *model = [NAURLCenter getSmsConfigForPhoneLoginWithPhoneNumber:self.phoneTextField.text];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [weakSelf startSmsTime];
        [SVProgressHUD showWithStatus:@"验证码已发送"];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:@"该手机号还未注册"];
        
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
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
    }
}
- (IBAction)onLoginBtnClicked:(id)sender {
    [self requestForPhoneLogin];
}

-(void)textFieldDidValueChanged:(UITextField *)textField {
    if (self.phoneTextField.text.length > 0 && self.smsTextField.text.length > 0) {
        self.loginBtn.enabled = YES;
        [self.loginBtn setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
    }
    else {
        self.loginBtn.enabled = NO;
        [self.loginBtn setBackgroundImage:kGetImage(@"login_btn_gray") forState:UIControlStateNormal];
    }
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        self.phoneImgView.image = kGetImage(@"login_user");
    }
    else if (textField == self.smsTextField) {
        self.smsImgView.image = kGetImage(@"register_sms");
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        self.phoneImgView.image = kGetImage(@"login_user_gray");
    }
    else if (textField == self.smsTextField) {
        self.smsImgView.image = kGetImage(@"register_sms_gray");
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTextField resignFirstResponder];
    [self.smsTextField resignFirstResponder];
}

@end
