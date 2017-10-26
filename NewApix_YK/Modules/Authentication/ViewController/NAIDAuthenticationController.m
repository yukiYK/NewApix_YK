//
//  NAIDAuthenticationController.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/12.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAIDAuthenticationController.h"
#import <AESCrypt.h>
#import "NSString+NAExtension.h"

static NSString * const idImageName = @"idImage.png";

@interface NAIDAuthenticationController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *stepTwoImageView;
@property (weak, nonatomic) IBOutlet UIButton *idCardPhotoBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idNumberTextField;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

/** 身份证照片 */
//@property (nonatomic, strong) UIImage *idCardImage;

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
        
        if ([NSData dataWithContentsOfFile:[idImageName documentPath]]) {
            self.checkBtn.enabled = YES;
            [self.checkBtn setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
        }
    }
    
    if ([[NAUserTool getSex] isEqualToString:@"女"]) {
        [self.idCardPhotoBtn setBackgroundImage:kGetImage(@"ID_up_female") forState:UIControlStateNormal];
    } else if ([[NAUserTool getSex] isEqualToString:@"男"]) {
        [self.idCardPhotoBtn setBackgroundImage:kGetImage(@"ID_up_male") forState:UIControlStateNormal];
    }
}

- (void)resetSubviews:(NSDictionary *)returnValue {
    
    if (returnValue && [returnValue[@"state"] integerValue] == 1) {
        NSDictionary *dataDic = returnValue[@"data"];
        NSString *sex = [NSString stringWithFormat:@"%@", dataDic[@"sex"]];
        self.nameTextField.text = [NSString stringWithFormat:@"%@", dataDic[@"name"]];
        self.idNumberTextField.text = [NSString stringWithFormat:@"%@", dataDic[@"number"]];
        
        [NAUserTool saveIdName:self.nameTextField.text];
        [NAUserTool saveIdNumber:[AESCrypt encrypt:self.idNumberTextField.text password:kAESKey]];
        [NAUserTool saveIdNation:[NSString stringWithFormat:@"%@", dataDic[@"nation"]]];
        [NAUserTool saveIdDetailedAddress:[NSString stringWithFormat:@"%@", dataDic[@"address"]]];
        
        if ([sex isEqualToString:@"女"]) {
            [self.idCardPhotoBtn setBackgroundImage:kGetImage(@"ID_up_female") forState:UIControlStateNormal];
        } else if ([sex isEqualToString:@"男"]) {
            [self.idCardPhotoBtn setBackgroundImage:kGetImage(@"ID_up_male") forState:UIControlStateNormal];
        }
        self.checkBtn.enabled = YES;
        [self.checkBtn setBackgroundImage:kGetImage(@"login_btn") forState:UIControlStateNormal];
        
        self.nameLabel.textColor = [UIColor blackColor];
        self.idNumberLabel.textColor = [UIColor blackColor];
    }
    else {
        [self.idCardPhotoBtn setBackgroundImage:kGetImage(@"ID_face_fail") forState:UIControlStateNormal];
    }
}

/** 校验身份证号 */
- (BOOL)isIdNumber:(NSString *)idNumber {
    NSString *PASSWORD = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORD];
    return [regextestmobile evaluateWithObject:idNumber];
}

#pragma mark - <Net Request>
- (void)requestForIdCardRecognitionWithImage:(UIImage *)image {
    UIImage *newImage = [image imageCompresstoMaxFileSize:1024 * 256];
    NAAPIModel *model = [NAURLCenter idCardRecognitionConfigWithPicDataStr:[newImage imageDataStr] picType:[newImage imageType]];
    
    [SVProgressHUD showWithStatus:@"照片识别中..."];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"582c254f23e04a886cfbe7a07b6cb36f" forHTTPHeaderField:@"apix-key"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    WeakSelf
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        if (returnValue) {
            [weakSelf resetSubviews:returnValue];
        }
        [SVProgressHUD dismiss];
        
    } errorCodeBlock:nil failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"识别失败，请重试"];
    }];
}

- (void)requestForIdAuthentication {
    // 图片名
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", timeInterval];
    NSString *fileName = [NSString stringWithFormat:@"%@idcard_photo.png",timeString];
    
    NSData *imageData = [NSData dataWithContentsOfFile:[idImageName documentPath]];
    
    NAAPIModel *model = [NAURLCenter idCardAuthenticationConfig];
    NSString *urlStr = [NAURLCenter urlWithType:NARequestURLTypeAPI pathArray:model.pathArr];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    [manager setRequestSerializerForPost];
    
    WeakSelf
    [manager netRequesPOSTWithRequestURL:urlStr parameter:model.param constructingBodyBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"idcard_photo" fileName:fileName mimeType:@"image/png"];
    } progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        // 跳转下一页
        [NAViewControllerCenter transformViewController:weakSelf
                                       toViewController:[NAViewControllerCenter idUserFaceController]
                                          tranformStyle:NATransformStylePush
                                              needLogin:NO];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        if ([code isEqualToString:@"-1"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:[NSString stringWithFormat:@"%@,如有疑问请联系客服4009-699-029",msg] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *isCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:isCancel];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

#pragma mark - <Events>
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
    if ([self isIdNumber:self.idNumberTextField.text]) {
        if ([NACommon getToken]) {
            [self requestForIdAuthentication];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请先登录"];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"您的身份证号码有误，请重新校对"];
    }
}



#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        NSString *filePath = [idImageName documentPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为idImage.png
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
        
        [self requestForIdCardRecognitionWithImage:image];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
