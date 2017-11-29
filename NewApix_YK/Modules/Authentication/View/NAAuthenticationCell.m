//
//  NAAuthenticationCell.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/11/29.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAAuthenticationCell.h"

@interface NAAuthenticationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation NAAuthenticationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellModel:(NAAuthenticationCellModel *)cellModel {
    _cellModel = cellModel;
    
    self.imgView.image = kGetImage([self imgNameWithOriginImgName:cellModel.imgName state:cellModel.state]);
    self.titleLabel.text = cellModel.title;
    self.statusLabel.text = [NAAuthenticationModel stringWithAuthenticationState:cellModel.state];
    self.statusLabel.textColor = [self textColorWithState:cellModel.state];
}

- (UIColor *)textColorWithState:(NAAuthenticationState)state {
    UIColor *color = kColorTextLightGray;
    switch (state) {
        case NAAuthenticationStateAlready:
        case NAAuthenticationStateCanUpdate:
        case NAAuthenticationStateAlreadyUpdate:
            color = kColorBlue;
            break;
        case NAAuthenticationStateOverdue:
            color = kColorTextRed;
            break;
            
        default:
            break;
    }
    return color;
}

- (NSString *)imgNameWithOriginImgName:(NSString *)imgName state:(NAAuthenticationState)state {
    NSString *newImgName = imgName;
    switch (state) {
        case NAAuthenticationStateAlready:
        case NAAuthenticationStateCanUpdate:
        case NAAuthenticationStateAlreadyUpdate:
            newImgName = [NSString stringWithFormat:@"%@_blue", imgName];
            break;
        case NAAuthenticationStateOverdue:
            newImgName = [NSString stringWithFormat:@"%@_red", imgName];
            break;
            
        default:
            break;
    }
    return newImgName;
}


@end
