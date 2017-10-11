//
//  NAAddCardController.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/10.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAAddCardController.h"
#import <AESCrypt.h>

@interface NAAddCardController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankCardNumberTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@property (nonatomic, strong) UIPickerView *bankTypePickerView;

@property (nonatomic, strong) UIView *checkSmsView;
@property (nonatomic, strong) UIButton *resendBtn;
@property (nonatomic, strong) UITextField *smsTextField;
@property (nonatomic, strong) UIButton *smsNextBtn;

@property (nonatomic, strong) NSArray *bankDataArr;

@end

@implementation NAAddCardController
#pragma mark - <Lazy Load>
- (NSArray *)bankDataArr {
    if (!_bankDataArr) {
        _bankDataArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bankType" ofType:@"plist"]];
    }
    return _bankDataArr;
}

- (UIView *)checkSmsView {
    if (!_checkSmsView) {
        _checkSmsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 29, kScreenWidth - 48, 20)];
        label.text = [NSString stringWithFormat:@"验证码已发送到手机号%@", self.phoneNumberTextField.text];
        label.font = [UIFont systemFontOfSize:15];
        [_checkSmsView addSubview:label];
        
        UIView *smsView = [[UIView alloc] initWithFrame:CGRectMake(26, CGRectGetMaxY(label.frame) + 10, kScreenWidth - 26 * 2, 60)];
        smsView.backgroundColor = [UIColor whiteColor];
        [_checkSmsView addSubview:smsView];
        
        CGFloat smsViewWidth = smsView.width;
        CGFloat resendBtnWidth = 100;
        UITextField *smsTextField = [[UITextField alloc] initWithFrame:CGRectMake(kCommonMargin, kCommonMargin, smsViewWidth - kCommonMargin * 2 - resendBtnWidth - 8, 30)];
        smsTextField.placeholder = @"短信验证码";
        smsTextField.font = [UIFont systemFontOfSize:18];
        [smsTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
        [smsView addSubview:smsTextField];
        self.smsTextField = smsTextField;
        
        UIButton *resendBtn = [[UIButton alloc] initWithFrame:CGRectMake(smsViewWidth - kCommonMargin - resendBtnWidth, kCommonMargin, resendBtnWidth, 30)];
        [resendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [resendBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [resendBtn setTitleColor:kColorLightBlue forState:UIControlStateNormal];
        [smsView addSubview:resendBtn];
        self.resendBtn = resendBtn;
        
        UIButton *smsNextBtn = [[UIButton alloc] initWithFrame:CGRectMake(26, CGRectGetMaxY(smsView.frame) + 26, kScreenWidth - 26 * 2, 44)];
        [smsNextBtn setBackgroundImage:kGetImage(@"login_btn_gray") forState:UIControlStateNormal];
        [smsNextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [smsNextBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [smsNextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [smsNextBtn addTarget:self action:@selector(onResendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_checkSmsView addSubview:smsNextBtn];
        self.smsNextBtn = smsNextBtn;
    }
    return _checkSmsView;
}

#pragma  mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"添加银行卡";
    [self addTextFieldTarget];
    [self setupTextFields];
}

- (void)setupTextFields {
    if ([NAUserTool getIdName] && [NAUserTool getIdNumber]) {
        self.nameTextField.text = [NAUserTool getIdName];
        self.idCardNumberTextField.text = [AESCrypt decrypt:[NAUserTool getIdNumber] password:kAESKey];
    } else {
        [self requestForUserInfo];
    }
    
    UIPickerView *bankTypePickerView = [[UIPickerView alloc] init];
    self.bankTypePickerView = bankTypePickerView;
    self.bankTypePickerView.backgroundColor = [UIColor lightGrayColor];
    self.bankTypePickerView.frame = CGRectMake(0, 0, kScreenWidth, 220);
    self.bankTypePickerView.delegate = self;
    self.bankTypePickerView.dataSource = self;
    [self.bankNameTextField setInputView:self.bankTypePickerView];
}

- (void)addTextFieldTarget {
//    [self.nameTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
//    [self.idCardNumberTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self.bankNameTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self.bankCardNumberTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
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
                
                [self.resendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                self.resendBtn.enabled = YES;
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.1];
                [self.resendBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.resendBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)showWarningAlert:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:[NSString stringWithFormat:@"%@",message] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *isCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *isok = [UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拨打电话
        [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:@"tel://4009699029"]];
    }];
    
    [alertController addAction:isCancel];
    [alertController addAction:isok];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - <Net Request>
- (void)requestForAddBankCard {
    NABankCardModel *bankcardModel = [[NABankCardModel alloc] init];
    bankcardModel.bank = self.bankNameTextField.text;
    bankcardModel.cardNumber = self.bankCardNumberTextField.text;
    bankcardModel.cardPhone = self.phoneNumberTextField.text;
    NAAPIModel *model = [NAURLCenter addBankCardConfigWithModel:bankcardModel];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    [manager setRequestSerializerForPost];
    WeakSelf
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        NSString *code = [NSString stringWithFormat:@"%@", returnValue[@"code"]];
        NSDictionary *dataDic = returnValue[@"data"];
        NSString *message = [NSString stringWithFormat:@"%@", dataDic[@"msg"]];
        NSString *loginCode = [NSString stringWithFormat:@"%@", returnValue[@"apix_login_code"]];
        if ([code isEqualToString:@"0"]) {
            [weakSelf requestForSendSms];
            weakSelf.bgScrollView.hidden = YES;
            [weakSelf.view addSubview:weakSelf.checkSmsView];
        } else if ([code isEqualToString:@"1"]) {
            if ([message isEqualToString:@"绑定银行卡为信用卡"]) {
                [SVProgressHUD showErrorWithStatus:@"您绑定的是信用卡，请绑定银行卡"];
            } else if ([loginCode isEqualToString:@"-1"]) {
                [NAUserTool removeAllUserDefaults];
            } else {
                [weakSelf showWarningAlert:message];
            }
        }
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

- (void)requestForSendSms {
    NAAPIModel *model = [NAURLCenter getSmsConfigForResetPasswordWithPhoneNumber:self.phoneNumberTextField.text];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
//        [SVProgressHUD showWithStatus:@"验证码已发送"];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
//        [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
    } failureBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

- (void)requestForBankValidate {
    NAAPIModel *model = [NAURLCenter validateBankCardConfigWithSmsCode:self.smsTextField.text phone:self.phoneNumberTextField.text cardNumber:self.bankCardNumberTextField.text];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

- (void)requestForUserInfo {
    
    NAAPIModel *model = [NAURLCenter mineUserInfoConfig];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    [manager setRequestSerializerForPost];
    
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        if ([returnValue[@"code"] integerValue] == -1) {
        } else if ([returnValue[@"apix_login_code"] integerValue] == -1) {
            [NAUserTool removeAllUserDefaults];
            [SVProgressHUD showErrorWithStatus:@"您的账号已在别处登录，请重新登录"];
            //            [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter loginController] tranformStyle:NATransformStylePush needLogin:NO];
        } else {
            NAUserInfoModel *model = [NAUserInfoModel yy_modelWithJSON:returnValue[@"data"]];
            self.nameTextField.text = model.name;
            self.idCardNumberTextField.text = [AESCrypt decrypt:model.id_number password:kAESKey];
        }
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - <Events>
- (void)textFieldValueChanged:(UITextField *)textField {
    if (textField == self.smsTextField) {
        if (self.smsTextField.text.length > 0) {
            self.smsNextBtn.enabled = YES;
            [self.smsNextBtn setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
        } else {
            self.smsNextBtn.enabled = NO;
            [self.smsNextBtn setBackgroundImage:kGetImage(@"login_btn_gray") forState:UIControlStateNormal];
        }
    } else {
        if (self.nameTextField.text.length > 0 && self.idCardNumberTextField.text.length > 0 && self.phoneNumberTextField.text.length > 0 && self.bankNameTextField.text.length > 0 && self.bankCardNumberTextField.text.length > 0) {
            self.nextStepBtn.enabled = YES;
            [self.nextStepBtn setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
        } else {
            self.nextStepBtn.enabled = NO;
            [self.nextStepBtn setBackgroundImage:kGetImage(@"login_btn_gray") forState:UIControlStateNormal];
        }
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

- (void)onResendBtnClicked:(UIButton *)button {
    
    [self requestForSendSms];
    [self startSmsTime];
}

#pragma mark - <UIPickerViewDelegate, UIPickerViewDataSource>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.bankDataArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.bankDataArr[row] objectForKey:@"title"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.bankNameTextField.text = [self.bankDataArr[row] objectForKey:@"title"];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end
