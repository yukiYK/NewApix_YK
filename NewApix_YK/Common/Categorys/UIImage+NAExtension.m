//
//  UIImage+NAExtension.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "UIImage+NAExtension.h"

@implementation UIImage (NAExtension)

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

@end
