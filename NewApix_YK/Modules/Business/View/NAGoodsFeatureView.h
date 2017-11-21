//
//  NAGoodsFeatureView.h
//  NewApix_YK
//
//  Created by APiX on 2017/11/20.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAGoodsChildModel.h"

typedef void(^CompleteBlock) (NAGoodsChildModel *childModel);

@interface NAGoodsFeatureView : UIView

@property (nonatomic, copy) CompleteBlock block;

- (instancetype)initWithTitle1:(NSString *)title1 title2:(NSString *)title2 childArr:(NSArray *)childArr;

- (void)show;

@end
