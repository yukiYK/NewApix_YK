//
//  NAPhoneLoginController.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/25.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAPhoneLoginController.h"

@interface NAPhoneLoginController ()

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



@end
