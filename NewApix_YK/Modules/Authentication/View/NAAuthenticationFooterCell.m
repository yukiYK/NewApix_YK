//
//  NAAuthenticationFooterCell.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/11/30.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAAuthenticationFooterCell.h"

@interface NAAuthenticationFooterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseBankCardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;
@property (weak, nonatomic) IBOutlet UIButton *allowBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;

@property (weak, nonatomic) IBOutlet UIView *chooseBankView;

@end


@implementation NAAuthenticationFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onChooseBankCardClicked:)];
    [self.chooseBankView addGestureRecognizer:tapGes];
}

- (void)setBankIcon:(NSString *)bankIcon bankName:(NSString *)bankName {
    [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:bankIcon]];
    self.bankCardLabel.text = bankName;
}

- (void)setIsBankChosen:(BOOL)isBankChosen {
    if (isBankChosen) {
        self.bankImageView.hidden = NO;
        self.bankCardLabel.hidden = NO;
        self.chooseBankCardLabel.hidden = YES;
    } else {
        self.bankImageView.hidden = YES;
        self.bankCardLabel.hidden = YES;
        self.chooseBankCardLabel.hidden = NO;
    }
}

- (void)onChooseBankCardClicked:(id)sender {
    if (self.chooseBankBlock)
        self.chooseBankBlock();
}

- (IBAction)onAlowBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (self.allowBlock)
        self.allowBlock(button.selected);
}

- (IBAction)onProtocolBtnClicked:(id)sender {
    if (self.protocolBlock)
        self.protocolBlock();
}

@end
