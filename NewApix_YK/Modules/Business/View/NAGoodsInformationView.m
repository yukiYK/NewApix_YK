//
//  NAGoodsInformationView.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/16.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAGoodsInformationView.h"

@interface NAGoodsInformationView ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipPrice;
@property (weak, nonatomic) IBOutlet UILabel *tag1Label;
@property (weak, nonatomic) IBOutlet UILabel *tag2Label;


@end

@implementation NAGoodsInformationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setGoodsModel:(NAGoodsModel *)goodsModel childModel:(NAGoodsChildModel *)childModel tags:(NSArray *)tags {
    
    
    self.height = 90 - 18 + self.descriptionLabel.height;
}


@end
