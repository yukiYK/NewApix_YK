//
//  NAAuthenticationWebController.h
//  NewApix_YK
//
//  Created by APiX on 2017/10/19.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NABaseViewController.h"

typedef NS_ENUM(NSInteger, NAAuthenticationType) {
    NAAuthenticationTypeService = 3,
    NAAuthenticationTypeJD,
    NAAuthenticationTypeTB,
    NAAuthenticationTypeSchool,
    NAAuthenticationTypeHouse,
    NAAuthenticationTypeLoan
};

@interface NAAuthenticationWebController : NABaseViewController

@property (nonatomic, assign) NAAuthenticationType authenticationType;

/** NAAuthenticationTypeLoan类型专用，其他不需要 */
@property (nonatomic, assign) NSInteger loanStep;

@end
