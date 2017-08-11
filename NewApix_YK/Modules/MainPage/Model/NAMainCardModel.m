//
//  NAMainCardModel.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/7.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAMainCardModel.h"

@implementation NAMainCardModel

- (CGFloat)cellHeight {
    
    CGFloat cellHeight = 0;
    if (self.card_type == 7 || self.card_type == 8 || self.card_type == 9) {
        cellHeight = 15 + (kScreenWidth - 30)/2.2 + 15;
    }
    else if (![self.img checkEmpty]) {
        cellHeight = 35 + (kScreenWidth - 30)/2.2 + 30;
    }
    else {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        CGRect labelRect = [self.description boundingRectWithSize:CGSizeMake(kScreenWidth - 30, 45) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
        cellHeight = 35 + labelRect.size.height + 30;
    }
    
    return cellHeight + 8;
}

@end
