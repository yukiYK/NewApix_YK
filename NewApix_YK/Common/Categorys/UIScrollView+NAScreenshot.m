//
//  UIScrollView+NAScreenshot.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/6.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "UIScrollView+NAScreenshot.h"

@implementation UIScrollView (NAScreenshot)

- (UIImage *)convertScrollViewToImage {
    
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.contentSize, NO, 0.0);
    {
        CGPoint savedContentOffset = self.contentOffset;
        CGRect savedFrame = self.frame;
        self.contentOffset = CGPointZero;
        self.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        
        [self.layer renderInContext: UIGraphicsGetCurrentContext()];
        // [self drawViewHierarchyInRect:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height) afterScreenUpdates:YES];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.contentOffset = savedContentOffset;
        self.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}

@end
