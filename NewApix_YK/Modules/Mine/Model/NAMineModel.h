//
//  NAMineModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/22.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAMineModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, strong) UIColor *detailTextColor;
@property (nonatomic, strong) UIColor *detailBgColor;
@property (nonatomic, copy) NSString *rightIcon;
@property (nonatomic, assign) CGFloat detailRightCons;

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon detail:(NSString *)detail;

@end
