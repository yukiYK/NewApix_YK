//
//  NAChooseBankCardView.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/12/1.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAChooseBankCardView.h"
#import "NAChooseBankCardCell.h"

@interface NAChooseBankCardView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cardArr;

@end


@implementation NAChooseBankCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithBankCardArr:(NSArray *)cardArr {
    if (self = [super init]) {
        self.cardArr = cardArr;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
}

@end
