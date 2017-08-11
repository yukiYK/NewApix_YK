//
//  NAMainPageCell.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/7.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAMainPageCell.h"

@interface NAMainPageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftTopIcon;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *showMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *showMoreBtn1;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailImageTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailImageHCons;

@end

@implementation NAMainPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.detailImageHCons.constant = (kScreenWidth - 30)/2.2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCardModel:(NAMainCardModel *)cardModel {
    _cardModel = cardModel;
    
    [self.leftTopIcon sd_setImageWithURL:[NSURL URLWithString:cardModel.card_type_img]];
    self.topTitleLabel.text = cardModel.name;
    [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.img] placeholderImage:[kGetImage(kImageDefault) cutImageAdaptImageViewSize:CGSizeMake(kScreenWidth - 30, (kScreenWidth - 30)/2.2)]];
    self.detailLabel.text = cardModel.description;
    self.bottomLabel.text = cardModel.bottom_button_name;
    
    if (![cardModel.top_button_name checkEmpty]) {
        self.showMoreBtn.hidden = NO;
        self.showMoreBtn1.hidden = NO;
        [self.showMoreBtn setTitle:cardModel.top_button_name forState:UIControlStateNormal];
    }
    else {
        self.showMoreBtn.hidden = YES;
        self.showMoreBtn1.hidden = YES;
    }
    
    if (cardModel.card_type == 7 || cardModel.card_type == 8 || cardModel.card_type == 9) {
        self.leftTopIcon.hidden = YES;
        self.topTitleLabel.hidden = YES;
        self.showMoreBtn1.hidden = YES;
        self.showMoreBtn.hidden = YES;
        self.bottomLabel.hidden = YES;
        self.detailImageView.hidden = NO;
        self.detailLabel.hidden = YES;
        
        self.detailImageTopCons.constant = 15;
    }
    else {
        self.leftTopIcon.hidden = NO;
        self.topTitleLabel.hidden = NO;
        self.showMoreBtn1.hidden = NO;
        self.showMoreBtn.hidden = NO;
        self.bottomLabel.hidden = NO;
        
        self.detailImageTopCons.constant = 35;
        
        if (![cardModel.img checkEmpty]) {
            self.detailImageView.hidden = NO;
            self.detailLabel.hidden = YES;
        }
        else {
            self.detailImageView.hidden = YES;
            self.detailLabel.hidden = NO;
        }
    }
}

@end
