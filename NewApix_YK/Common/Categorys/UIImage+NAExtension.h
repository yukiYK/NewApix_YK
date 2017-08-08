//
//  UIImage+NAExtension.h
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NAExtension)

/** 裁剪图片适应imageView的size */
- (UIImage *)cutImageAdaptImageViewSize:(CGSize)imageViewSize;

@end
