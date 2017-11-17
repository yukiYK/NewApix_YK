//
//  NAGoodsInformationView.h
//  NewApix_YK
//
//  Created by APiX on 2017/11/16.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAGoodsModel.h"
#import "NAGoodsChildModel.h"

@interface NAGoodsInformationView : UIView


/**
 填充数据

 @param goodsModel NAGoodsModel
 @param childModel NAGoodsChildModel
 @param tags [{"name":"XX"}, {"name":"XX"}]
 */
- (void)setGoodsModel:(NAGoodsModel *)goodsModel childModel:(NAGoodsChildModel *)childModel tags:(NSArray *)tags;

@end
