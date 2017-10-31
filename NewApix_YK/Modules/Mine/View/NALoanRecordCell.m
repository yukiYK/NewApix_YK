//
//  NALoanRecordCell.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/30.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NALoanRecordCell.h"

@interface NALoanRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *loanNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loanTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *loanMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIView *pointView;

/** 根据贷款状态获取文案 */
@property (nonatomic, strong) NSArray *loanStatusArray;

@end


@implementation NALoanRecordCell
- (NSArray *)loanStatusArray {
    if (!_loanStatusArray) {
        _loanStatusArray = @[@"审核中", @"未通过", @"已结清", @"逾期中", @"已放款", @"放款中"];
    }
    return _loanStatusArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLoanModel:(NALoanRecordModel *)loanModel {
    _loanModel = loanModel;
    
    self.loanNumberLabel.text = loanModel.number;
    self.loanMoneyLabel.text = [NSString stringWithFormat:@"贷款金额:%@元", loanModel.money];
    self.loanDurationLabel.text = [NSString stringWithFormat:@"贷款期限:%@天", loanModel.day];
    self.payMoneyLabel.text = [NSString stringWithFormat:@"应还金额:%.2f元", loanModel.sum];
    self.loanTimeLabel.text = [NSString stringWithFormat:@"(%@)", loanModel.created_at];
    self.statusLabel.text = self.loanStatusArray[loanModel.loanStatus];
    self.pointView.backgroundColor = loanModel.pointColor;
    
    self.loanTypeImageView.image = loanModel.assortment == 1 ? kGetImage(@"loan_vip") : kGetImage(@"loan_fast");
}


@end
