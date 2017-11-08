//
//  NAShareView.h
//  NewApix_YK
//
//  Created by APiX on 2017/11/6.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

/**
 按钮点击事件

 @param sharePlatform 分享平台
 */
typedef void(^NAShareActionBlock) (UMSocialPlatformType sharePlatform);

@interface NAShareView : UIView

- (instancetype)initWithActionBlock:(NAShareActionBlock)actionBlock;

- (void)show;

- (void)hide;

@end
