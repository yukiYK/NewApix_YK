//
//  NANewPhoneController.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/29.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NANewPhoneController.h"
#import "NATabbarController.h"

@interface NANewPhoneController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *smsImgView;
@property (weak, nonatomic) IBOutlet UIButton *getSmsBtn;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation NANewPhoneController
#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"修改手机号";
    [self.smsTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - <Private Method>
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

#pragma mark - <NetRequest>
- (void)requestForGetSms {
    NAAPIModel *model = [NAURLCenter getSmsConfigForRegisterWithPhoneNumber:self.phoneTextField.text];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [weakSelf startSmsTime];
        [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        if ([code isEqualToString:@"-3"]) {
            [SVProgressHUD showErrorWithStatus:@"该手机号已经注册过了"];
        }
        else [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

- (void)requestSetNewPhone {
    NAAPIModel *model = [NAURLCenter setNewPhoneConfigWithPhone:self.phoneTextField.text smsCode:self.smsTextField.text];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    [manager setRequestSerializerForPost];
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        
        [SVProgressHUD showSuccessWithStatus:@"手机号修改成功"];
        if (![NACommon getToken]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            [self requestForLogout];
        }
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:@"验证失败"];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

- (void)requestForLogout {
    NAAPIModel *model = [NAURLCenter logoutConfig];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    [manager setRequestSerializerForPost];
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [NAUserTool removeAllUserDefaults];
        NATabbarController *apixTabVC = [[NATabbarController alloc] init];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].keyWindow.rootViewController = apixTabVC;
        });
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
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

- (IBAction)onSubmitBtnClicked:(id)sender {
    [self requestSetNewPhone];
}

-(void)textFieldDidValueChanged:(UITextField *)textField {
    if (self.phoneTextField.text.length > 0 && self.smsTextField.text.length > 0) {
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
