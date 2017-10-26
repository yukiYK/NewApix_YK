//
//  NAIDFaceCameraController.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/16.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAIDFaceCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>

@interface NAIDFaceCameraController ()

@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *flashBtn;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;


@property (nonatomic, strong) UIView *preview;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (nonatomic, assign) AVCaptureDevicePosition cameraPosition;
@property (nonatomic, assign) AVCaptureTorchMode cameraFlash;

@end

@implementation NAIDFaceCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.customTitleLabel.text = @"身份验证";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startCamera];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.preview.frame = self.view.bounds;
    self.captureVideoPreviewLayer.bounds = self.preview.bounds;
    self.captureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(self.preview.bounds), CGRectGetMidY(self.preview.bounds));
    
    AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
    
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortraitUpsideDown:
            videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationLandscapeRight:
            videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        default:
            break;
    }
    self.captureVideoPreviewLayer.connection.videoOrientation = videoOrientation;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - <Private Methods>
- (void)startCamera {
    if (!_session) {
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
        
        self.preview = [[UIView alloc] initWithFrame:CGRectZero];
        self.preview.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:self.preview atIndex:0];
        
        CALayer *viewLayer = self.preview.layer;
        CGRect bounds = viewLayer.bounds;
        
        AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        captureVideoPreviewLayer.bounds = bounds;
        captureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        [self.preview.layer addSublayer:captureVideoPreviewLayer];
        self.captureVideoPreviewLayer = captureVideoPreviewLayer;
        
        
        [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] enumerateObjectsUsingBlock:^(AVCaptureDevice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AVCaptureDevice *dev = (AVCaptureDevice *)obj;
            if ([dev position] == AVCaptureDevicePositionFront) {
                self.captureDevice = dev;
                *stop = YES;
            }
        }];
        
        if (!_captureDevice)
            self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
        if (!input) return;
        
        [self.session addInput:input];
        
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [self.stillImageOutput setOutputSettings:outputSettings];
        [self.session addOutput:self.stillImageOutput];
    }
    [self.session startRunning];
}

- (void)stopCamera {
    [self.session stopRunning];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) return device;
    }
    return nil;
}

- (AVCaptureConnection *)captureConnection {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in connection.inputPorts) {
            if (port.mediaType == AVMediaTypeVideo) {
                videoConnection = connection;
                break;
            }
            if (videoConnection) break;
        }
    }
    return videoConnection;
}

/** 捕获相机里的图片 */
- (void)captureImage {
    AVCaptureConnection *videoConnection = [self captureConnection];
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments) {
        } else {
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        
        CGSize sizeface = CGSizeMake(320.0f, 480.0f);
        UIImage *imagelive = [image imageCompressToSize:sizeface];
        
        NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
        CIContext *context;
        CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
        CIImage *imagelive1 = [CIImage imageWithCGImage:imagelive.CGImage];
        NSArray *features = [faceDetector featuresInImage:imagelive1];
        
        BOOL isSuccess = YES;
        if (features.count == 0) {
            isSuccess = NO;
            [SVProgressHUD showErrorWithStatus:@"请对准脸部拍照！"];
        }
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"验证成功～"];
            if (self.endBlock) self.endBlock(imagelive);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

/** 切换输入设备 */
- (void)changeDeviceInput {
    AVCaptureInput *currentCameraInput = self.session.inputs.firstObject;
    if (((AVCaptureDeviceInput *)currentCameraInput).device.position == self.cameraPosition)
        return;
    
    [self.session beginConfiguration];
    // 移除旧输入设备
    [self.session removeInput:currentCameraInput];
    
    // 添加新的输入设备
    AVCaptureDevice *newCamera = [self cameraWithPosition:self.cameraPosition];
    if (!newCamera) return;
    
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:nil];
    [self.session addInput:newVideoInput];
    // 提交新配置
    [self.session commitConfiguration];
    self.captureDevice = newCamera;
}

/** 切换闪光灯模式 */
- (void)changeFlashModel {
    AVCaptureInput *currentCameraInput = self.session.inputs.firstObject;
    AVCaptureDeviceInput *deviceInput = (AVCaptureDeviceInput *)currentCameraInput;
    if (!deviceInput.device.isTorchActive) return;
    
    if (deviceInput.device.torchMode == self.cameraFlash) return;
    
    [self.session beginConfiguration];
    [deviceInput.device lockForConfiguration:nil];
    deviceInput.device.torchMode = self.cameraFlash;
    [deviceInput.device unlockForConfiguration];
    [self.session commitConfiguration];
}

#pragma mark - <Events>

- (IBAction)onTakePhotoBtnClicked:(id)sender {
    [self captureImage];
}

- (IBAction)onFlashBtnClicked:(id)sender {
    if (self.cameraFlash == AVCaptureTorchModeOn) {
        self.cameraFlash = AVCaptureTorchModeOff;
        self.flashBtn.selected = NO;
    } else {
        self.cameraFlash = AVCaptureTorchModeOn;
        self.flashBtn.selected = YES;
    }
    
    [self changeFlashModel];
}

- (IBAction)onSwitchBtnClicked:(id)sender {
    if (self.cameraPosition == AVCaptureDevicePositionBack) {
        self.cameraPosition = AVCaptureDevicePositionFront;
    } else {
        self.cameraPosition = AVCaptureDevicePositionBack;
    }
    
    [self changeDeviceInput];
}

- (IBAction)onCloseBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
