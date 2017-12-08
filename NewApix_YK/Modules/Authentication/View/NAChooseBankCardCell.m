//
//  NAChooseBankCardCell.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/12/1.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAChooseBankCardCell.h"

@interface NAChooseBankCardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNumberLabel;


@end

@implementation NAChooseBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCardModel:(NABankCardModel *)cardModel {
    _cardModel = cardModel;
    
    [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:cardModel.img]];
    self.bankNameLabel.text = cardModel.bank;
    self.bankNumberLabel.text = [cardModel.cardNumber substringFromIndex:cardModel.cardNumber.length - 4];
}

@end
