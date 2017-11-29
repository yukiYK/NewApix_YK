//
//  NAAuthenticationCell.h
//  NewApix_YK
//
//  Created by hg-macair on 2017/11/29.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAAuthenticationModel.h"

@interface NAAuthenticationCellModel : NSObject

@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NAAuthenticationState state;

@end



@interface NAAuthenticationCell : UICollectionViewCell

@property (nonatomic, strong) NAAuthenticationCellModel *cellModel;

@end
