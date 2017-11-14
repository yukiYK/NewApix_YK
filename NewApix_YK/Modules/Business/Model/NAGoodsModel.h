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
/** 商品id */
@property (nonatomic, copy) NSString *id;
/** 商品类型 1.话费 2.视频卡 3.实物 */
@property (nonatomic, assign) NSInteger order_type;
/** 产品规格 颜色 尺寸分类 */
@property (nonatomic, copy) NSString *main_feature_title;
/** 详情 */
@property (nonatomic, copy) NSString *secondary_feature_title;

@end
