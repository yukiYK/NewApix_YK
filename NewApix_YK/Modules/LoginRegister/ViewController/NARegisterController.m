//
//  NARegisterController.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NARegisterController.h"

@interface NARegisterController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UITextField *imageSmsTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *smsImgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSmsImgView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImgView;

@property (weak, nonatomic) IBOutlet UIImageView *bigImgSmsImgView;

@property (weak, nonatomic) IBOutlet UIButton *getSmsBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordVisibleBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


@end

@implementation NARegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPasswordVisibleClicked:(id)sender {
}
- (IBAction)onGetSmsClicked:(id)sender {
}
- (IBAction)onUserProtocolClicked:(id)sender {
}
- (IBAction)onAgreeClicked:(id)sender {
}

- (IBAction)onRegisterBtnClicked:(id)sender {
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
