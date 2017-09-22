//
//  NAAddressController.h
//  NewApix_YK
//
//  Created by APiX on 2017/9/11.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NABaseViewController.h"
#import "NAAddressModel.h"

typedef void (^ChangeAddressCompleteBlock) (NAAddressModel *model);

@interface NAAddressController : NABaseViewController

@property (nonatomic, copy) ChangeAddressCompleteBlock completeBlock;

@end
