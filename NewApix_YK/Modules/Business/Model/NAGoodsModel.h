//
//  NAGoodsModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/11/9.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAGoodsModel : NSObject

/** 图片 */
@property (nonatomic, copy) NSString *img;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 副标题 */
@property (nonatomic, copy) NSString *attraction;
/** 原价 */
@property (nonatomic, copy) NSString *price;
/** vip价 */
@property (nonatomic, copy) NSString *vip_price;

@end
