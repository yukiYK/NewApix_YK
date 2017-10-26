//
//  NAIDFaceCameraController.h
//  NewApix_YK
//
//  Created by APiX on 2017/10/16.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NABaseViewController.h"

typedef void (^CameraDidEndBlock) (UIImage *image);

@interface NAIDFaceCameraController : NABaseViewController

@property (nonatomic, copy) CameraDidEndBlock endBlock;

@end
