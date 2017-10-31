//
//  NALoanRecordModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/10/30.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NALoanStatus) {
    NALoanStatusrReviewing,// 审核中
    NALoanStatusFailed,    // 未通过
    NALoanStatusComplete,  // 已结清
    NALoanStatusOverdue,   // 逾期中
    NALoanStatusGranted,   // 已放款
    NALoanStatusGranting   // 放款中
};


@interface NALoanRecordModel : NSObject

/** 贷款编号 */
@property (nonatomic, copy) NSString *number;
/** 贷款金额 */
@property (nonatomic, copy) NSString *money;
/** 贷款日期 */
@property (nonatomic, copy) NSString *created_at;
/** 贷款期限 */
@property (nonatomic, copy) NSString *day;
/** 贷款类型 1.无息贷款 2.快贷 */
@property (nonatomic, assign) NSInteger assortment;
/** 应还金额 */
@property (nonatomic, assign) CGFloat sum;
/** 贷款状态 */
@property (nonatomic, assign) NALoanStatus loanStatus;
/** 贷款状态后面的点颜色 */
@property (nonatomic, strong) UIColor *pointColor;


/**
 解析方法

 @param loanDic 接口返回的数据字典
 @return NALoanRecordModel对象
 */
+ (instancetype)modelWithLoanDic:(NSDictionary *)loanDic;

@end
