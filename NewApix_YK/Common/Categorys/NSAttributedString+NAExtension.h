//
//  NSAttributedString+NAExtension.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/11.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (NAExtension)


/**
 使用图片和文本生成上下排列的属性文本

 @param image 图片
 @param imageWH 图像宽高
 @param title 标题文字
 @param fontSize 标题字体大小
 @param titleColor 标题颜色
 @param spacing 图片和标题间距
 @return 属性文本
 */
+ (instancetype)attributedStringWithImage:(UIImage *)image
                              imageWH:(CGFloat)imageWH
                                title:(NSString *)title
                             fontSize:(CGFloat)fontSize
                           titleColor:(UIColor *)titleColor
                              spacing:(CGFloat)spacing;

@end
