//
//  NAShareView.h
//  NewApix_YK
//
//  Created by APiX on 2017/11/6.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 按钮点击事件

 @param index 按钮index 0开始 依次 是微信、朋友圈、QQ、QQ空间
 */
typedef void(^NAShareActionBlock) (NSInteger index);

@interface NAShareView : UIView

- (instancetype)initWithActionBlock:(NAShareActionBlock)actionBlock;

- (void)show;

- (void)hide;

@end
