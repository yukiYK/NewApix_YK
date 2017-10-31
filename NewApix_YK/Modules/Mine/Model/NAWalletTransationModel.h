//
//  NAWalletTransationModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/10/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAWalletTransationModel : NSObject

/** 交易类型 1.收入 2.支出 */
@property (nonatomic, assign) NSInteger transaction_type;
/** 具体类型 1.邀请注册 2.购买会员 4.转发-我要赚钱 5。注册体验金 */
@property (nonatomic, assign) NSInteger transaction_content;
/** 交易日期 */
@property (nonatomic, copy) NSString *time_h;
/** 交易日期详情 */
@property (nonatomic, copy) NSString *time_b;
/** 交易金额 */
@property (nonatomic, copy) NSString *amount;
/** 描述信息 */
@property (nonatomic, copy) NSString *note;
/** 邀请人名字 */
@property (nonatomic, copy) NSString *name;

@end
