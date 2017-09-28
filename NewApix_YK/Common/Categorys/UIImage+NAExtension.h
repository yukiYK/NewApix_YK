//
//  UIImage+NAExtension.h
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NAExtension)

/** 生成一张纯色的图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 裁剪图片适应imageView的size */
- (UIImage *)cutImageAdaptImageViewSize:(CGSize)imageViewSize;

/** 上下拼接两张图片 */
- (UIImage *)stitchBottomImage:(UIImage *)bottomImage;

/** 压缩图片 */
- (UIImage *)imageCompresstoMaxFileSize:(NSInteger)maxFileSize;

@end
