//
//  NAMainCardModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/7.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAMainCardModel : NSObject

/** card的跳转链接 */
@property (nonatomic, copy) NSString *bottom_button_link;
/** 底部label */
@property (nonatomic, copy) NSString *bottom_button_name;
/**  */
@property (nonatomic, assign) NSInteger bottom_button_type;
/** card类型
 *  3 banner 
 *  4 热卡推荐   5 智能推荐，菠萝贷等等    6 会员文章
 *  7 视频卡列表
 *  8 商品详情   9 商城页面   12攻略  13无息贷款   21新加非会员无息贷款  14-20暂不用
 */
@property (nonatomic, assign) NSInteger card_type;
/**  */
@property (nonatomic, copy) NSString *card_type_img;
/**  */
@property (nonatomic, copy) NSString *card_type_name;
/** 详情label */
@property (nonatomic, copy) NSString *description;
/**  */
@property (nonatomic, assign) NSInteger id;
/** 中间大图 */
@property (nonatomic, copy) NSString *img;
/** 上面标题 */
@property (nonatomic, copy) NSString *name;
/**  */
@property (nonatomic, copy) NSString *top_button_link;
/**  */
@property (nonatomic, copy) NSString *top_button_name;
/**  */
@property (nonatomic, assign) NSInteger top_button_type;
/**  */
@property (nonatomic, assign) NSInteger weight;


/** model对应的cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
