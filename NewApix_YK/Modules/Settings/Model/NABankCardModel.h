//
//  NABankCardModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/10/9.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NABankCardModel : NSObject

@property (nonatomic, copy) NSString *cardid;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, copy) NSString *cardNumber;
@property (nonatomic, copy) NSString *cardPhone;

/** 拼信用页选择银行卡用 */
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *cardno;
@property (nonatomic, copy) NSString *logo;

@end
