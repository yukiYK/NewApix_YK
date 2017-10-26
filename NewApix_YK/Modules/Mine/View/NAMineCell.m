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
@property (weak, nonatomic) IBOutlet UIImageView *nextImgView;
@property (weak, nonatomic) IBOutlet UIView *redPointView;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLabelTrailingCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLabelWidthCons;

@end

@implementation NAMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetAllSubviews {
    self.rightLabel.textColor = kColorTextLightGray;
    self.rightLabel.backgroundColor = [UIColor clearColor];
    self.rightLabelTrailingCons.constant = 20;
    self.rightImageView.hidden = YES;
    self.redPointView.hidden = YES;
}

- (void)setModel:(NAMineModel *)model {
    _model = model;
    
    [self resetAllSubviews];
    
    
    self.titleLabel.text = model.title;
    self.iconImageView.image = kGetImage(model.icon);
    self.rightLabel.text = model.detail;
    if (model.detail) {
        UILabel *label = [[UILabel alloc] init];
        label.text = model.detail;
        label.font = self.rightLabel.font;
        [label sizeToFit];
        self.rightLabelWidthCons.constant = label.width;
    }
}

- (void)setDetailTextColor:(UIColor *)color bgColor:(UIColor *)bgColor {
    self.rightLabel.textColor = color;
    if (bgColor) {
        self.rightLabel.backgroundColor = bgColor;
        self.rightLabelWidthCons.constant += 20;
    }
}

- (void)setRightIcon:(NSString *)rightIcon {
    self.rightImageView.hidden = NO;
    self.rightImageView.image = kGetImage(rightIcon);
    self.rightLabelTrailingCons.constant = 42;
}

- (void)showRedPoint:(BOOL)isShow {
    self.redPointView.hidden = !isShow;
    if (isShow) self.rightLabelTrailingCons.constant = 32;
}

@end
