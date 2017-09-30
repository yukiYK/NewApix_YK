//
//  NAChangePasswordController.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/29.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAChangePasswordController.h"
#import "NATabbarController.h"

@interface NAChangePasswordController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *oldVisibleBtn;
@property (weak, nonatomic) IBOutlet UIButton *visibleBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation NAChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"修改密码";
    [self.oldPasswordTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)isPassword:(NSString *)password {
    NSString *str = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    
    return [predicate evaluateWithObject:password];
}


- (void)requestForChangePassword {
    NAAPIModel *model = [NAURLCenter changePasswordConfigWithPwd:self.passwordTextField.text oldpwd:self.oldPasswordTextField.text];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    [manager setRequestSerializerForPost];
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
        [self requestForLogout];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        if ([code isEqualToString:@"-1"])
            [SVProgressHUD showErrorWithStatus:msg];
    } failureBlock:^(NSError *error) {
        
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

- (IBAction)onVisibleBtnClicked:(id)sender {
    UIButton *button = sender;
    button.selected = !button.selected;
    
    if (button == self.oldVisibleBtn)
        self.oldPasswordTextField.secureTextEntry = !self.oldPasswordTextField.secureTextEntry;
    else
        self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
}

- (IBAction)onSubmitBtnClicked:(id)sender {
    if ([self isPassword:self.passwordTextField.text]) {
        [self requestForChangePassword];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"密码必须是6-20位字母数字组合"];
    }
}

-(void)textFieldDidValueChanged:(UITextField *)textField {
    if (self.oldPasswordTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.submitButton.enabled = YES;
        [self.submitButton setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
    }
    else {
        self.submitButton.enabled = NO;
        [self.submitButton setBackgroundImage:kGetImage(@"login_btn_gray") forState:UIControlStateNormal];
    }
}

@end
