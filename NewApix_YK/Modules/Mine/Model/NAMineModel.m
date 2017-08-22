//
//  NAMineModel.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/22.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAMineModel.h"

@implementation NAMineModel

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon detail:(NSString *)detail {
    if (self = [super init]) {
        self.title = title;
        self.icon = icon;
        self.detail = detail;
    }
    return self;
}

@end
