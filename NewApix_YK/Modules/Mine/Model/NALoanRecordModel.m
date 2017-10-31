//
//  NALoanRecordModel.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/30.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NALoanRecordModel.h"

@implementation NALoanRecordModel

/**
 解析方法
 
 @param loanDic 接口返回的数据字典
 @return NALoanRecordModel对象
 */
+ (instancetype)modelWithLoanDic:(NSDictionary *)loanDic {
    NSDictionary *dic = loanDic[@"loan"];
    NALoanRecordModel *instance = [NALoanRecordModel yy_modelWithJSON:dic];
    NSRange range = [instance.created_at rangeOfString:@"T"];
    instance.created_at = [instance.created_at substringToIndex:range.location];
    instance.assortment = [loanDic[@"assortment"] integerValue];
    
    NSArray *arr = loanDic[@"data"] ? loanDic[@"data"] : [[NSArray alloc] init];
    if (arr.count > 0) {
        instance.sum = [arr[0][@"sum"] floatValue] / 100;
    }
    
    NSInteger status = [dic[@"status"] integerValue];
    NALoanStatus loanStatus = NALoanStatusGranting;
    UIColor *pointColor = kColorLightBlue;
    if (status == 1) {
        loanStatus = NALoanStatusrReviewing;
        pointColor = kColorTextRed;
    } else if (status == 2) {
        loanStatus = NALoanStatusFailed;
        pointColor = kColorTextLightGray;
    } else if (status == 3) {
        NSInteger payOff = [dic[@"pay_off"] integerValue];
        NSInteger isOverdue = [dic[@"is_it_overdue"] integerValue];
        NSInteger grant = [dic[@"grant"] integerValue];
        if (payOff == 1 || payOff == 2) {
            loanStatus = NALoanStatusComplete;
            pointColor = kColorTextLightGray;
        } else if (isOverdue == 1) {
            loanStatus = NALoanStatusOverdue;
            pointColor = kColorTextRed;
        } else if (grant == 1) {
            loanStatus = NALoanStatusGranted;
            pointColor = kColorBlue;
        }
    }
    instance.loanStatus = loanStatus;
    instance.pointColor = pointColor;
    
    return instance;
}

/*
 status  0想申请 、1审核中、2 审核失败 、3审核成功
 
 pay_off  是否全额还清（1提前还款、2正常）
 is_it_overdue 是否逾期（1为逾期、2正常）
 grant = 1 已放款  放款中
 */

//#define kColorGraySeperator [UIColor colorFromString:@"f2f2f2"]
//#define kColorLightBlue  [UIColor colorFromString:@"89abe3"]
//#define kColorTextBlack [UIColor colorFromString:@"333333"]
//#define kColorTextLightGray [UIColor colorFromString:@"999999"]
//#define kColorHeaderGray [UIColor colorFromString:@"f4f4f4"]
//#define kColorTextYellow [UIColor colorFromString:@"D3B27D"]
//#define kColorTextRed  [UIColor colorFromString:@"ff6766"]
//#define kColorLightPink [UIColor colorFromString:@"f7cac9"]
//#define kColorLightGreen [UIColor colorFromString:@"69c69d"]
//#define kColorBlue [UIColor colorFromString:@"5999ff"]
@end
