//
//  NAAuthenticationTitleCell.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/11/29.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAAuthenticationTitleCell.h"

@interface NAAuthenticationTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation NAAuthenticationTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

@end
