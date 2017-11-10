//
//  NAGoodsListTitleCell.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/10.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAGoodsListTitleCell.h"

@interface NAGoodsListTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end


@implementation NAGoodsListTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

@end
