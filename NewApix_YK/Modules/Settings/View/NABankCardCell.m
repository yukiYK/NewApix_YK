//
//  NABankCardCell.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/9.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NABankCardCell.h"

@interface NABankCardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

@end


@implementation NABankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBankCardModel:(NABankCardModel *)bankCardModel {
    [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:bankCardModel.img]];
    self.cardTypeLabel.text = bankCardModel.cardType;
    self.bankLabel.text = bankCardModel.bank;
    self.cardNumberLabel.text = bankCardModel.cardNumber;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
