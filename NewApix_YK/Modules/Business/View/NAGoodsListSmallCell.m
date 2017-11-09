//
//  NAGoodsListSmallCell.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/9.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAGoodsListSmallCell.h"

@interface NAGoodsListSmallCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;


@end

//120+128

@implementation NAGoodsListSmallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoodsModel:(NAGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    
    CGFloat imageViewWidth = (kScreenWidth - 60) / 3;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.img] placeholderImage:[kGetImage(kImageDefault) cutImageAdaptImageViewSize:CGSizeMake(imageViewWidth, imageViewWidth)]];
    self.titleLabel.text = goodsModel.title;
    self.subTitleLabel.text = goodsModel.attraction;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", goodsModel.vip_price];
    self.originalPriceLabel.text = [NSString stringWithFormat:@"原价:¥%@", goodsModel.price];
}



@end
