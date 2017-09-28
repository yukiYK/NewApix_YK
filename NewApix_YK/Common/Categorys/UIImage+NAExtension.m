//
//  UIImage+NAExtension.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "UIImage+NAExtension.h"

@implementation UIImage (NAExtension)

+ (UIImage *)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (UIImage *)cutImageAdaptImageViewSize:(CGSize)imageViewSize {
    //裁剪图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((self.size.width / self.size.height) < (imageViewSize.width / imageViewSize.height)) {
        newSize.width = self.size.width;
        newSize.height = self.size.width * imageViewSize.height / imageViewSize.width;
        
        imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(0, fabs(self.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = self.size.height;
        newSize.width = self.size.height * imageViewSize.width / imageViewSize.height;
        
        imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(fabs(self.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}

/** 上下拼接两张图片 */
- (UIImage *)stitchBottomImage:(UIImage *)bottomImage {
    
    CGSize size = CGSizeMake(self.size.width, self.size.height + bottomImage.size.height);
    UIGraphicsBeginImageContextWithOptions(size, 0, 0);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [bottomImage drawInRect:CGRectMake(0, self.size.height, bottomImage.size.width, bottomImage.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/** 压缩图片 */
- (UIImage *)imageCompresstoMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

@end
