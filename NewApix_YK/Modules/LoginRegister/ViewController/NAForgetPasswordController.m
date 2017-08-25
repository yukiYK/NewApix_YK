//
//  NAForgetPasswordController.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/25.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAForgetPasswordController.h"

@interface NAForgetPasswordController ()

@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *smsImgView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getSmsBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordVisibleBtn;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation NAForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGetSmsBtnClicked:(id)sender {
}
- (IBAction)onPasswordVisibleBtnClicked:(id)sender {
}
- (IBAction)onSubmitBtnClicked:(id)sender {
}

@end
