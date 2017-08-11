//
//  NABannerView.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/7.
//  Copyright © 2017年 APiX. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NAMainCardModel.h"

typedef void(^BannerClickedBlock) (NAMainCardModel *cardModel);

@interface NABannerView : UIView



/**
 初始化方法 默认开启Animation自动切换，需要关闭请手动调用stopAnimation

 @param frame frame大小
 @param cardArray cardModel的数组
 @param clickBlock 点击事件block
 @return view对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                    cardArray:(NSArray *)cardArray
                   clickBlock:(BannerClickedBlock)clickBlock;

/** 更新banner数据 默认开启Animation自动切换，需要关闭请手动调用stopAnimation */
- (void)setupWithCardArray:(NSArray *)cardArray clickBlock:(BannerClickedBlock)clickBlock;

/** 开始动画 在页面WillAppear的时候调用 */
- (void)startAnimation;
/** 停止动画，在页面DidDisappear的时候调用 最好调用下，否则定时器不会被销毁 */
- (void)stopAnimation;

@end
