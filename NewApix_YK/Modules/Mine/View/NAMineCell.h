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

- (void)setDetailTextColor:(UIColor *)color;

@end
