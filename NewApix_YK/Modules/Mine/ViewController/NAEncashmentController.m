//
//  NAEncashmentController.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/1.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAEncashmentController.h"

@interface NAEncashmentController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation NAEncashmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"提现";
    [self setupSubviews];
}

- (void)setupSubviews {
    self.allMoneyLabel.text = self.allMoney;
    
    [self.textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:@"暂不支持自动提现，发起申请后请加官方微信号：meixinmarket领取现金红包"];
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromString:@"89abe3"] range:[[noteStr1 string] rangeOfString:@"meixinmarket"]];
    [self.tipsLabel setAttributedText:noteStr1];
    self.tipsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTipsLabelClicked:)];
    [self.tipsLabel addGestureRecognizer:tapGes];
}

- (BOOL)isCorrectNumber:(NSString *)str {
    NSString *MOBILE = @"^\\d+\\.{0,1}\\d{0,2}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:str];
}

- (void)showSuccessAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提交成功" message:@"请添加小美微信号meixinmarket领取现金" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - <Net Request>
- (void)requestForEncashment {
    NAAPIModel *model = [NAURLCenter encashmentConfigWithMoney:self.textField.text];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        if ([returnValue[@"ok"] integerValue] == 1) {
            [self showSuccessAlert];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else [SVProgressHUD showErrorWithStatus:returnValue[@"msg"]];
    } errorCodeBlock:nil failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"未知错误"];
    }];
}

#pragma mark - <Events>
- (void)onTipsLabelClicked:(id)sender {
    [[UIPasteboard generalPasteboard] setString:@"meixinmarket"];
    [SVProgressHUD showSuccessWithStatus:@"已复制微信号"];
}

- (IBAction)onSubmitBtnClicked:(id)sender {
    if ([self.textField.text integerValue] > [self.allMoney integerValue]) {
        [SVProgressHUD showErrorWithStatus:@"提现金额不能大于余额"];
        return;
    }
    if (![self isCorrectNumber:self.textField.text]) {
        [SVProgressHUD showErrorWithStatus:@"输入金额的小数应小于等于两位"];
        return;
    }
    
    [self requestForEncashment];
}

- (void)textFieldValueChanged:(UITextField *)textField {
    if ([self.textField.text integerValue] > 0) {
        self.submitBtn.enabled = YES;
        [self.submitBtn setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
    } else {
        self.submitBtn.enabled = NO;
        [self.submitBtn setBackgroundImage:kGetImage(@"login_btn_gray") forState:UIControlStateNormal];
    }
}

@end
