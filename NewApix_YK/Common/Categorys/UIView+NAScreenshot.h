//
//  UIView+NAScreenshot.h
//  NewApix_YK
//
//  Created by APiX on 2017/9/6.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NAScreenshot)

- (UIImage *)convertViewToImage;

/**
 截取view的某块区域
 
 @param rect 要截取的区域
 @return 截取生成的image
 */
- (UIImage *)imageFromViewRect:(CGRect)rect;

@end
