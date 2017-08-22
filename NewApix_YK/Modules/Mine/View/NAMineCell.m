//
//  NAMineCell.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/18.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAMineCell.h"

@interface NAMineCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;


@end

@implementation NAMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NAMineModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.iconImageView.image = kGetImage(model.icon);
    self.rightLabel.text = model.detail;
}

- (void)setDetailTextColor:(UIColor *)color {
    self.rightLabel.textColor = color;
}

@end
