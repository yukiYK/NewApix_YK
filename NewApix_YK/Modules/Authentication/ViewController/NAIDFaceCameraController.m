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

@property (nonatomic, strong) UIView *preview;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@end

@implementation NAIDFaceCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"身份验证";
    
    
    
}


#pragma mark - <Private Methods>
- (void)startCamera {
    if (!_session) {
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
        
        self.preview = [[UIView alloc] initWithFrame:CGRectZero];
        self.preview.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.preview];
        
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
    
}




@end
