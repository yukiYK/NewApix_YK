//
//  NAVideoVIPListCell.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/11/24.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAVideoVIPListCell.h"

@interface NAVideoVIPListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePointLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipPriceLabel;

@end

@implementation NAVideoVIPListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.videoImageView.layer.borderColor = [UIColor colorFromString:@"dadada"].CGColor;
}

- (void)setGoodsModel:(NAGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.img] placeholderImage:[kGetImage(kImageDefault) cutImageAdaptImageViewSize:CGSizeMake(self.videoImageView.width, self.videoImageView.height)]];
    self.titleLabel.text = goodsModel.title;
    self.salePointLabel.text = goodsModel.attraction;
    self.priceLabel.text = goodsModel.price;
    self.vipPriceLabel.text = goodsModel.vip_price;
}

@end
