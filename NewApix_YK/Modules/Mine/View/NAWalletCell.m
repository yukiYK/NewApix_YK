//
//  NAWalletCell.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAWalletCell.h"

@interface NAWalletCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@end

@implementation NAWalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTransationModel:(NAWalletTransationModel *)transationModel {
    _transationModel = transationModel;
    
    self.dateLabel.text = transationModel.time_h;
    self.detailTimeLabel.text = transationModel.time_b;
    self.moneyLabel.text = transationModel.amount;
    
    NSString *description = transationModel.note;
    UIImage *image = kGetImage(@"wallet_regist");
    if (transationModel.transaction_content == 1) {
        description = [NSString stringWithFormat:@"邀请%@注册美信账号(%@)", transationModel.name, transationModel.note];
    } else if (transationModel.transaction_content == 2) {
        description = [NSString stringWithFormat:@"好友%@购买了%@(购买)", transationModel.name, transationModel.note];
        image = kGetImage(@"wallet_buy");
    } else if (transationModel.transaction_content == 4) {
        description = @"转发-我要赚钱";
        image = kGetImage(@"wallet_share");
    }
    self.descriptionLabel.text = description;
    self.typeImageView.image = image;
    
    
    if (transationModel.transaction_type == 2) {
        self.moneyLabel.text = [NSString stringWithFormat:@"-%@", transationModel.amount];
        self.typeImageView.image = kGetImage(@"wallet_crash");
        self.descriptionLabel.text = transationModel.note;
    }
}

@end
