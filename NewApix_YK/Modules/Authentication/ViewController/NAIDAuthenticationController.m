//
//  NAIDAuthenticationController.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/12.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAIDAuthenticationController.h"
#import <AESCrypt.h>

@interface NAIDAuthenticationController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *stepTwoImageView;
@property (weak, nonatomic) IBOutlet UIButton *idCardPhotoBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idNumberTextField;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation NAIDAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"身份认证";
    
    [self setupTextField];
}

- (void)setupTextField {
    if ([NAUserTool getIdName] && [NAUserTool getIdNumber]) {
        self.nameTextField.text = [NAUserTool getIdName];
        self.idNumberTextField.text = [AESCrypt decrypt:[NAUserTool getIdNumber] password:kAESKey];
        
        self.checkBtn.enabled = YES;
        [self.checkBtn setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
    }
    
    if ([[NAUserTool getSex] isEqualToString:@"女"]) {
        [self.idCardPhotoBtn setImage:kGetImage(@"ID_up_female") forState:UIControlStateNormal];
    } else if ([[NAUserTool getSex] isEqualToString:@"男"]) {
        [self.idCardPhotoBtn setImage:kGetImage(@"ID_up_male") forState:UIControlStateNormal];
    }
}



- (IBAction)onIdCardBtnClicked:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [SVProgressHUD showErrorWithStatus:@"未找到相机功能"];
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (IBAction)onCheckBtnClicked:(id)sender {
    []
}


#pragma mark - <Net Request>
- (void)requestForIdCardAuthenticationWithImage:(UIImage *)image {
    UIImage *newImage = [image imageCompresstoMaxFileSize:1024 * 1024 * 2];
    NAAPIModel *model = [NAURLCenter idCardAuthenticationConfigWithPicDataStr:[newImage imageDataStr] picType:[newImage imageType]];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
    } errorCodeBlock:nil failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}


#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        [self requestForIdCardAuthenticationWithImage:image];
    }
}

@end
