//
//  NAEssenceCell.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/14.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAEssenceCell.h"

@interface NAEssenceCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingAmountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@end

@implementation NAEssenceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NAEssenceModel *)model {
    
}

@end
