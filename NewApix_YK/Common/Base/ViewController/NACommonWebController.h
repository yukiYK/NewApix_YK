//
//  NACommonWebController.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/11.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NABaseViewController.h"
#import "NAMainCardModel.h"

@interface NACommonWebController : NABaseViewController

@property (nonatomic, assign) BOOL isShowShareBtn;
@property (nonatomic, strong) NAMainCardModel *cardModel;

@end
