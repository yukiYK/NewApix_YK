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
@property (weak, nonatomic) IBOutlet UILabel *vipPriceLabel;
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
    
    self.descriptionLabel.text = goodsModel.title;
    [self.descriptionLabel sizeToFit];
    self.informationLabel.text = goodsModel.attraction;
    self.priceLabel.text = childModel.price;
    self.vipPriceLabel.text = [NSString stringWithFormat:@"会员价 ¥%@", childModel.second_class_cost];
    
    self.height = 90 - 18 + self.descriptionLabel.height;
    
    self.tag1Label.layer.borderColor = [UIColor whiteColor].CGColor;
    self.tag2Label.layer.borderColor = [UIColor whiteColor].CGColor;
    if (!tags || tags.count <= 0) {
        self.tag1Label.hidden = YES;
        self.tag2Label.hidden = YES;
    } else if (tags.count == 1) {
        self.tag1Label.hidden = YES;
        self.tag2Label.hidden = NO;
        self.tag2Label.text = tags[0][@"name"];
    } else if (tags.count >= 2) {
        self.tag1Label.hidden = NO;
        self.tag2Label.hidden = NO;
        self.tag1Label.text = tags[0][@"name"];
        self.tag2Label.text = tags[1][@"name"];
    }
    
    
}


@end
