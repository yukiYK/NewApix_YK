//
//  NAAddressController.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/11.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAAddressController.h"
#import "NAPickerView.h"

@interface NAAddressController () <UITextFieldDelegate, NAPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgScrollViewTopCons;

@property (nonatomic, strong) NAPickerView *pickerView;
@property (nonatomic, strong) UITextField *editingTextField;

@property (nonatomic, strong) NAAddressModel *addressModel;
//@property (nonatomic, copy) NSString *province;  // 省
//@property (nonatomic, copy) NSString *city;      // 市
//@property (nonatomic, copy) NSString *district;  // 区/县
///** 用来判断是否是新增地址（以前没填过则为nil） */
//@property (nonatomic, copy) NSString *addressId;

@end

@implementation NAAddressController
#pragma mark - <Lazy Load>
- (NAAddressModel *)addressModel {
    if (!_addressModel) {
        _addressModel = [[NAAddressModel alloc] init];
    }
    return _addressModel;
}

- (NAPickerView *)pickerView {
    if (!_pickerView) {
        NSString *plistStr = [[NSBundle mainBundle] pathForResource:@"areaArray" ofType:@"plist"];
        NSArray *areaArray = [NSArray arrayWithContentsOfFile:plistStr];
        
        _pickerView = [[NAPickerView alloc] initWithDataArray:areaArray pickerViewStyle:NAPickerViewStyleLinkageColumn];
        [_pickerView setResultKeyArr:@[@"provinceName", @"cityName", @"areaName"] nextKeyArr:@[@"citylist", @"arealist"]];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"收货地址";
//    [self setupSubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

// 更新UI
- (void)resetSubviewsWith:(NAAddressModel *)model {
    self.nameTextField.text = model.receiver;
    self.phoneTextField.text = model.receiver_phone;
    self.addressTextField.text = [NSString stringWithFormat:@"%@%@%@", model.province, model.city, model.district];
    self.detailAddressTextField.text = model.address;
    self.saveButton.enabled = YES;
    
    self.addressModel = model;
}

#pragma mark - <Net Request>
- (void)requestForAddress {
    NAAPIModel *model = [NAURLCenter userAddressConfig];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        NSArray *addressArr = [NSArray arrayWithArray:returnValue[@"address"]];
        if (addressArr.count <= 0) {
            weakSelf.addressModel.id = nil;
        }
        else {
            NAAddressModel *model = [NAAddressModel yy_modelWithJSON:addressArr[0]];
            [weakSelf resetSubviewsWith:model];
        }
        
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)requestForChangeAddress {
    self.addressModel.receiver = self.nameTextField.text;
    self.addressModel.receiver_phone = self.phoneTextField.text;
    self.addressModel.address = self.detailAddressTextField.text;
    NAAPIModel *model = [NAURLCenter updateAddressConfigWithReceiver:self.addressModel.receiver
                                                       receiverPhone:self.addressModel.receiver_phone
                                                            province:self.addressModel.province
                                                                city:self.addressModel.city
                                                            district:self.addressModel.district
                                                             address:self.addressModel.address
                                                                  id:self.addressModel.id];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        if (self.completeBlock) self.completeBlock(self.addressModel);
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - <Events>
- (IBAction)showPickerView:(id)sender {
    [self.pickerView show];
}

- (IBAction)onSaveButtonClicked:(id)sender {
    
}

#pragma mark - <NAPickerViewDelegate>
- (void)pickerViewCompleteWithResult:(NSArray *)resultArr {
    NSString *addressStr = @"";
    for (int i=0;i<resultArr.count;i++) {
        [addressStr stringByAppendingString:[NSString stringWithFormat:@"%@ ", resultArr[i]]];
    }
    [addressStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.addressTextField.text = addressStr;
    
    if (resultArr.count < 3) return;
    self.addressModel.province = resultArr[0];
    self.addressModel.city = resultArr[1];
    self.addressModel.district = resultArr[2];
}

- (void)pickerViewCancel {
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.editingTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length <= 0) self.saveButton.enabled = NO;
    
    if (self.phoneTextField.text.length > 0 && self.nameTextField.text.length > 0 && self.addressTextField.text.length > 0 && self.detailAddressTextField.text.length > 0)
        self.saveButton.enabled = YES;
}

#pragma mark - <Notification>
/* 键盘通知调用的方法 **/
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    
    // 滑动tableView
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat height = 64 + CGRectGetMaxY(self.editingTextField.frame) + 8;
    if (height > kScreenHeight - keyboardFrame.size.height) {
        CGFloat offsetY = height - (kScreenHeight - keyboardFrame.size.height);
        [self.bgScrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
}

@end
