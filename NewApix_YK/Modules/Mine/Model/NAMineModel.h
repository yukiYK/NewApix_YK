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

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon detail:(NSString *)detail;

@end
