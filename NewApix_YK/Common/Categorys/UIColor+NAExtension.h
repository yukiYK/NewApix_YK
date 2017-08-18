//
//  UIColor+NAExtension.h
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 颜色相关的宏 */
//#define kCustomRed [UIColor colorWithRed:255 / 255.0 green:56 / 255.0 blue:46 / 255.0 alpha:1]
//#define kDeepGray [UIColor colorWithRed:132 / 255.0 green:133 / 255.0 blue:133 / 255.0 alpha:1];
//
//#define kEvenLineColor [UIColor whiteColor]
//#define kOddLineColor [UIColor colorWithRed:244/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]
//#define kCellBackgroundColor (indexPath.row % 2 == 0 ?  [UIColor colorWithRed:244/255.0 green:249/255.0 blue:249/255.0 alpha:1.0] : [UIColor whiteColor])
//
//#define kLightBlueColor [UIColor colorFromString:@"4285f4"]
//#define kTextGrayColor [UIColor colorFromString:@"848585"]

//#define kDeepBlueColor [UIColor colorFromString:@"OD5BDD"]

//#define kCoinGrayColor [UIColor colorFromString:@"9e9e9e"]
//#define kCoinYellowColor [UIColor colorFromString:@"d9a75f"]
//#define kGrayBackgroundColor [UIColor colorFromString:@"f8f8f8"]
//#define kWPRedColor [UIColor colorFromString:@"ff382e"]
//#define kWPBlueColor [UIColor colorFromString:@"526cce"]
//#define kSeparatorViewColor [UIColor colorFromString:@"e0e0e0"]

#define kColorGraySeperator [UIColor colorFromString:@"f2f2f2"]
#define kColorLightBlue  [UIColor colorFromString:@"89abe3"]
#define kColorBlackText [UIColor colorFromString:@"333333"]
#define kColorTextLightGray [UIColor colorFromString:@"999999"]
#define kColorHeaderGray [UIColor colorFromString:@"f4f4f4"]


@interface UIColor (NAExtension)

/**
 根据6位的16进制色值生成颜色

 @param str 6位的16进制色值
 @return 一个UIColor对象
 */
+ (UIColor *)colorFromString:(NSString *)str;

+ (UIColor *)colorFromString:(NSString *)str alpha:(CGFloat)alpha;

@end
