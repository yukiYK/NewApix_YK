//
//  NAGoodsChildModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/11/17.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAGoodsChildModel : NSObject

/** 默认价 */
@property (nonatomic, copy) NSString *default_price;
/** 会员价 */
@property (nonatomic, copy) NSString *second_class_cost;
/** 商品规格1的值 */
@property (nonatomic, copy) NSString *main_feature;
/** 商品id */
@property (nonatomic, copy) NSString *id;
/** 原价 */
@property (nonatomic, copy) NSString *price;
/** 商品规格2的值 */
@property (nonatomic, copy) NSString *secondary_feature;
/** 库存 */
@property (nonatomic, copy) NSString *stock;

@end
