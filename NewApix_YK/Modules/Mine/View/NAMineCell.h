//
//  NAMineCell.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/18.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAMineModel.h"

@interface NAMineCell : UITableViewCell

@property (nonatomic, strong) NAMineModel *model;

- (void)setDetailTextColor:(UIColor *)color bgColor:(UIColor *)bgColor;

/** 设置右边小图标，不能和小红点同时用 */
- (void)setRightIcon:(NSString *)rightIcon;
/** 是否显示右边小红点，不能和右边小图标同时用 */
- (void)showRedPoint:(BOOL)isShow;

@end
