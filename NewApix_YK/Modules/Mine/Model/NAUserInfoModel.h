//
//  NAUserInfoModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/21.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAUserInfoModel : NSObject

/** 地址 */
@property (nonatomic, copy) NSString *address;
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 学历 */
@property (nonatomic, copy) NSString *education;
/** 身份证号 */
@property (nonatomic, copy) NSString *id_number;
/** 婚姻背景 */
@property (nonatomic, copy) NSString *marry_info;
/** 名字 */
@property (nonatomic, copy) NSString *name;
/** 昵称 */
@property (nonatomic, copy) NSString *nick_name;
/** 手机号 */
@property (nonatomic, copy) NSString *phone_number;
/** 职业 */
@property (nonatomic, copy) NSString *profession;
/** qq */
@property (nonatomic, copy) NSString *qq;

@end
