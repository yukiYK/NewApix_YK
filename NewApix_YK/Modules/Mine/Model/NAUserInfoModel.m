//
//  NAUserInfoModel.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/21.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAUserInfoModel.h"

@implementation NAUserInfoModel

// 用户相关信息保存本地
- (void)setName:(NSString *)name {
    [NAUserTool saveIdName:name];
}
- (NSString *)name {
    return [NAUserTool getIdName];
}

- (void)setAvatar:(NSString *)avatar {
    [NAUserTool saveAvatar:avatar];
}
- (NSString *)avatar {
    return [NAUserTool getAvatar];
}

- (void)setNick_name:(NSString *)nick_name {
    [NAUserTool saveNick:nick_name];
}
- (NSString *)nick_name {
    return [NAUserTool getNick];
}

- (void)setId_number:(NSString *)id_number {
    [NAUserTool saveIdNumber:id_number];
}
- (NSString *)id_number {
    return [NAUserTool getIdNumber];
}

- (void)setPhone_number:(NSString *)phone_number {
    [NAUserTool savePhoneNumber:phone_number];
}
- (NSString *)phone_number {
    return [NAUserTool getPhoneNunber];
}

@end
