//
//  NAChooseBankCardCell.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/12/1.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAChooseBankCardCell.h"
#import <AESCrypt/AESCrypt.h>

@interface NAChooseBankCardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNumberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *chooseImgView;

@end

@implementation NAChooseBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCardModel:(NABankCardModel *)cardModel {
    _cardModel = cardModel;
    
    [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:cardModel.logo]];
    self.bankNameLabel.text = cardModel.bank_name;
    NSString *cardNum = [AESCrypt decrypt:cardModel.cardno password:kAESKey];
    self.bankNumberLabel.text = [cardNum substringFromIndex:cardNum.length - 4];
}

- (void)setIsChosen:(BOOL)isChosen {
    _isChosen = isChosen;
    self.chooseImgView.image = isChosen ? kGetImage(@"choose_bank") : kGetImage(@"choose_bank_gray");
}

@end
