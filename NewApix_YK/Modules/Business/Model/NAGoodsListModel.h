//
//  NAGoodsListModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/11/10.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAGoodsListModel : NSObject

/** 列表标题 */
@property (nonatomic, copy) NSString *name;
/** 商品列表类型 2.每行两个 3.每行3个 */
@property (nonatomic, assign) NSInteger window_type;
/** 具体每个商品列表里的商品数组 */
@property (nonatomic, strong) NSArray *products;

@end
