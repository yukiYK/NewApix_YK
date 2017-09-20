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

@property (nonatomic, strong) NAPickerView *pickerView;

@property (nonatomic, strong) UITextField *editingTextField;

@end

@implementation NAAddressController
#pragma mark - <Lazy Load>
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.addressTextField setInputView:self.pickerView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - <NAPickerViewDelegate>
- (void)pickerViewCompleteWithResult:(NSArray *)resultArr {
    NSString *addressStr = @"";
    for (int i=0;i<resultArr.count;i++) {
        [addressStr stringByAppendingString:[NSString stringWithFormat:@"%@ ", resultArr[i]]];
    }
    [addressStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.addressTextField.text = addressStr;
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.editingTextField = textField;
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
