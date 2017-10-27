//
//  NAMineWalletModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/10/27.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAMineWalletModel : NSObject

@property (nonatomic, copy) NSString *balance;
@property (nonatomic, strong) NSArray *transaction;
@property (nonatomic, copy) NSString *income;
@property (nonatomic, copy) NSString *advantage;
@property (nonatomic, copy) NSString *loan;


@end
