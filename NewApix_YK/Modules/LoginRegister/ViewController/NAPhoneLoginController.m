//
//  NAPhoneLoginController.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/25.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAPhoneLoginController.h"

@interface NAPhoneLoginController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *smsImgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UIButton *getSmsBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation NAPhoneLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)onGetSmsBtnClicked:(id)sender {
}
- (IBAction)onLoginBtnClicked:(id)sender {
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        self.phoneImgView.image = kGetImage(@"login_user");
    }
    else if (textField == self.smsTextField) {
        self.smsImgView.image = kGetImage(@"login_sms");
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        self.phoneImgView.image = kGetImage(@"login_user_gray");
    }
    else if (textField == self.smsTextField) {
        self.smsImgView.image = kGetImage(@"login_sms_gray");
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTextField resignFirstResponder];
    [self.smsTextField resignFirstResponder];
}

@end
