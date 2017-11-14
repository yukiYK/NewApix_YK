//
//  NAGoodsPriceModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/11/13.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAGoodsPriceModel : NSObject

/** 原价 */
@property (nonatomic, copy) NSString *default_price;
/** 会员价 */
@property (nonatomic, copy) NSString *second_class_cost;
/**  */
@property (nonatomic, copy) NSString *main_feature;
/**  */
@property (nonatomic, copy) NSString *id;

@end
