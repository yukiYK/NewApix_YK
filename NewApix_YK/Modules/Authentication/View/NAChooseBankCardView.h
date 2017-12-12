//
//  NAChooseBankCardView.h
//  NewApix_YK
//
//  Created by hg-macair on 2017/12/1.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddCardBlock) (void);
typedef void(^ChooseCardBlock) (NABankCardModel *cardModel);

@interface NAChooseBankCardView : UIView

- (instancetype)initWithBankCardArr:(NSArray *)cardArr;

- (void)resetWithCardArr:(NSArray *)cardArr;

- (void)show;

@property (nonatomic, copy) AddCardBlock addCardBlock;
@property (nonatomic, copy) ChooseCardBlock chooseBlock;

@end
