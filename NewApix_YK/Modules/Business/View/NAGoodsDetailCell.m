//
//  NAGoodsDetailCell.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/15.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAGoodsDetailCell.h"

@interface NAGoodsDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation NAGoodsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title content:(NSString *)content {
    self.titleLabel.text = title;
    self.contentLabel.text = content;
}

@end
