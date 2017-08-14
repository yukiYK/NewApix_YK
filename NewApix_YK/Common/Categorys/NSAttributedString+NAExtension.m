//
//  NSAttributedString+NAExtension.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/11.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NSAttributedString+NAExtension.h"

@implementation NSAttributedString (NAExtension)

+ (instancetype)attributedStringWithImage:(UIImage *)image
                                  imageWH:(CGFloat)imageWH
                                    title:(NSString *)title
                                 fontSize:(CGFloat)fontSize
                               titleColor:(UIColor *)titleColor
                                  spacing:(CGFloat)spacing {
    // 文本字典
    NSDictionary *titleDict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                NSForegroundColorAttributeName: titleColor};
    NSDictionary *spacingDict = @{NSFontAttributeName: [UIFont systemFontOfSize:spacing]};
    
    // 图片文本
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, 0, imageWH, imageWH);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 换行文本
    NSAttributedString *lineText = [[NSAttributedString alloc] initWithString:@"\n\n" attributes:spacingDict];
    
    // 按钮文字
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:title attributes:titleDict];
    
    // 合并文字
    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
    [attM appendAttributedString:lineText];
    [attM appendAttributedString:text];
    
    return attM.copy;
}

@end
