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


@end

@implementation NAMainPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCardMadel:(NAMainCardModel *)cardMadel {
    
    
}

@end
