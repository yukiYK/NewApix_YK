//
//  NACommunityCell.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/14.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NACommunityCell.h"

@interface NACommunityCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@property (weak, nonatomic) IBOutlet UIImageView *avatarIcon;
@property (weak, nonatomic) IBOutlet UIButton *numberBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation NACommunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NACommunityModel *)model {
}

@end
