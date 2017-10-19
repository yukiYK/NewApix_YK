//
//  NAIDUserFaceController.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/16.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAIDUserFaceController.h"
#import "NAAuthenticationModel.h"

@interface NAIDUserFaceController ()


@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (nonatomic, strong) NSData *faceData;

@end

@implementation NAIDUserFaceController
#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"身份认证";
    [self setupSubviews];
    
}

- (void)setupSubviews {
    
}



#pragma mark - <Net Request>
- (void)requestForCheck {
    // 图片名
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", timeInterval];
    NSString *fileName = [NSString stringWithFormat:@"%@idcard_photo.png",timeString];
    
//    NSData *imageData = UIImageJPEGRepresentation(self.faceData,0.5);
    
    NAAPIModel *model = [NAURLCenter faceIdentityConfig];
    NSString *urlStr = [NAURLCenter urlWithType:NARequestURLTypeAPI pathArray:model.pathArr];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    [manager setRequestSerializerForPost];
    
    WeakSelf
    [manager netRequesPOSTWithRequestURL:urlStr parameter:model.param constructingBodyBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:self.faceData name:@"user_photo" fileName:fileName mimeType:@"image/png"];
    } progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [weakSelf requestForAuthenticationEnd];
    } errorCodeBlock:nil failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

// 身份认证完成
- (void)requestForAuthenticationEnd {
    NAAPIModel *model = [NAURLCenter authenticationSaveConfigWithStep:@"1" token:[NACommon getToken]];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [SVProgressHUD showSuccessWithStatus:@"认证成功，每月可更新认证一次"];
        // 更新用户的认证状态 信誉分
        [weakSelf requestForTrustScore];
        [weakSelf requestForAuthenticationStatus];
        
    } errorCodeBlock:nil failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

- (void)requestForTrustScore {
    NAAPIModel *model = [NAURLCenter trustScoreConfig];
    
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        [NAUserTool saveTrustSocre:returnValue[@"score"]];
    } errorCodeBlock:nil failureBlock:nil];
}

- (void)requestForAuthenticationStatus {
    NAAPIModel *model = [NAURLCenter authenticationStatusConfig];
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        [NAAuthenticationModel analysisAuthentication:returnValue];
    } errorCodeBlock:nil failureBlock:nil];
}

#pragma mark - <Events>
- (IBAction)onTakePhotoBtnClicked:(id)sender {
    [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter idFaceCameraController] tranformStyle:NATransformStylePush needLogin:NO];
}

- (IBAction)onCheckBtnClicked:(id)sender {
    
}

@end
