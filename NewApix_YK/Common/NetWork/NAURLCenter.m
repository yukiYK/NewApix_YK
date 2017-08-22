//
//  NAURLCenter.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/22.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAURLCenter.h"

@implementation NAURLCenter

/**
 拼接url
 
 @param urlType 请求的类型  api还是h5 等
 @param pathArray 路径  a/b/c...
 @return 拼接好的完整urlString
 */
+ (NSString *)urlWithType:(NARequestURLType)urlType pathArray:(NSArray *)pathArray {
    
    NSString *urlString = @"";
    switch (urlType) {
        case NARequestURLTypeAPI:
            urlString = SERVER_ADDRESS_API;
            break;
        case NARequestURLTypeH5:
            urlString = SERVER_ADDRESS_H5;
            break;
        default:
            break;
    }
    
    if (pathArray != nil && pathArray.count > 0) {
        for (NSString *path in pathArray) {
            urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
        }
    }
    NSLog(@"%@", urlString);
    return urlString;
}

/** 审核开关接口 */
+ (NAAPIModel *)onOrOffConfigWithName:(NSString *)name origin:(NSString *)origin {
    NAAPIModel *model = [[NAAPIModel alloc] init];
    model.requestType = NAHTTPRequestTypeGet;
    model.pathArr = [NSArray arrayWithObjects:@"api", @"control", nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"name"] = name;
    param[@"origin"] = origin;
    model.param = param;
    
    return model;
}

/** 首页卡片接口 */
+ (NAAPIModel *)mainPageCardConfigWithVersion:(NSString *)version {
    NAAPIModel *model = [[NAAPIModel alloc] init];
    model.requestType = NAHTTPRequestTypeGet;
    model.pathArr = [NSArray arrayWithObjects:@"api", @"cards", nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"version"] = version;
    model.param = param;
    
    return model;
}

/** 用户基本信息接口 昵称 头像等 */
+ (NAAPIModel *)mineUserInfoConfigWithToken:(NSString *)token {
    NAAPIModel *model = [[NAAPIModel alloc] init];
    model.requestType = NAHTTPRequestTypeGet;
    model.pathArr = [NSArray arrayWithObjects:@"api", @"user_infos", @"show", nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = token;
    model.param = param;
    
    return model;
}

/** 用户vip信息接口 */
+ (NAAPIModel *)mineVipInfoConfigWithToken:(NSString *)token {
    NAAPIModel *model = [[NAAPIModel alloc] init];
    model.requestType = NAHTTPRequestTypeGet;
    model.pathArr = [NSArray arrayWithObjects:@"api", @"vip", @"time", nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = token;
    param[@"code"] = @"0";
    model.param = param;
    
    return model;
}

/** 用户订单信息接口 */
+ (NAAPIModel *)mineOrderInfoConfigWithToken:(NSString *)token {
    NAAPIModel *model = [[NAAPIModel alloc] init];
    model.requestType = NAHTTPRequestTypeGet;
    model.pathArr = [NSArray arrayWithObjects:@"api", @"product", @"transactions", nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = token;
    model.param = param;
    
    return model;
}

/** 用户贷款记录接口 */
+ (NAAPIModel *)mineLoanListConfigWithToken:(NSString *)token {
    NAAPIModel *model = [[NAAPIModel alloc] init];
    model.requestType = NAHTTPRequestTypeGet;
    model.pathArr = [NSArray arrayWithObjects:@"api", @"meixin", @"loan", @"list", nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apix_token"] = token;
    model.param = param;
    
    return model;
}

@end
