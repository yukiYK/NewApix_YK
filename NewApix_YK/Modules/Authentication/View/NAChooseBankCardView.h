//
//  NAChooseBankCardView.h
//  NewApix_YK
//
//  Created by hg-macair on 2017/12/1.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddCardBlock) (void);

@interface NAChooseBankCardView : UIView

- (instancetype)initWithBankCardArr:(NSArray *)cardArr;

@property (nonatomic, copy) AddCardBlock addCardBlock;

@end
