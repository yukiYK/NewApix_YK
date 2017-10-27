//
//  NAMineOrderModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/21.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAMineOrderModel : NSObject

// 订单数量 小红点显示的
/** 进行中 */
@property (nonatomic, copy) NSString *paid;
/** 退款 */
@property (nonatomic, copy) NSString *refound;
/** 成功 */
@property (nonatomic, copy) NSString *success;
/** 我的订单 */
@property (nonatomic, copy) NSString *transactions;

@end
