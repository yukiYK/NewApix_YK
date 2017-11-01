//
//  NAWalletModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/10/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAWalletModel : NSObject

/** 钱包余额 */
@property (nonatomic, copy) NSString *balance;
/** 交易流水数组 */
@property (nonatomic, strong) NSArray *transaction;
/** 收入金额 */
@property (nonatomic, copy) NSString *income;
/** 节省金额 */
@property (nonatomic, copy) NSString *advantage;
/** 贷款金额 */
@property (nonatomic, copy) NSString *loan;

@end
