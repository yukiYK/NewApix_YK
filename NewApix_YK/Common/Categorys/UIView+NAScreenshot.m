//
//  UIView+NAScreenshot.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/6.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "UIView+NAScreenshot.h"

@implementation UIView (NAScreenshot)

- (UIImage *)convertViewToImage {
    
    
    //    CGSize size = CGSizeMake(kScreenWidth, kScreenHeight * 2);
    //    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight * 2);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);   // NO，YES控制是否透明
    //    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 截取view的某块区域
 
 @param rect 要截取的区域
 @return 截取生成的image
 */
- (UIImage *)imageFromViewRect:(CGRect)rect {
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size,NO, 1.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    CGRect myImageRect = rect;
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef,myImageRect );
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
