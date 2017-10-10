//
//  NAAddCardController.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/10.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAAddCardController.h"

@interface NAAddCardController ()

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankCardNumberTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@end

@implementation NAAddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"添加银行卡";
    [self addTextFieldTarget];
}

- (void)addTextFieldTarget {
//    [self.nameTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
//    [self.idCardNumberTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self.bankNameTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self.bankCardNumberTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    
    self.nameTextField.text = [NAUserTool getIdName];
    self.idCardNumberTextField.text = [NAUserTool getIdNumber];
}



- (void)requestForAddBankCard {
    
}

- (void)requestForSendSms {
    
}


- (void)textFieldValueChanged:(UITextField *)textField {
    if (self.nameTextField.text.length > 0 && self.idCardNumberTextField.text.length > 0 && self.phoneNumberTextField.text.length > 0 && self.bankNameTextField.text.length > 0 && self.bankCardNumberTextField.text.length > 0) {
        self.nextStepBtn.enabled = YES;
        [self.nextStepBtn setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
    } else {
        self.nextStepBtn.enabled = NO;
        [self.nextStepBtn setBackgroundImage:kGetImage(@"login_btn_gray") forState:UIControlStateNormal];
    }
}

- (IBAction)onTipsBtnClicked:(id)sender {
    [self.view endEditing:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"持卡人说明" message:@"为了你的账户资金安全，只能绑定持卡人本人的银行卡" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *isCancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:isCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)onNextStepBtnClicked:(id)sender {
    [self requestForAddBankCard];
}

@end
