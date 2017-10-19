//
//  NAAPIModel.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/22.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NARequestURLType) {
    NARequestURLTypeAPI,   // 美信后台接口
    NARequestURLTypeH5,    // 美信web
    NARequestURLTypeAPIXA, // apix接口a
    NARequestURLTypeAPIXE  // apix接口e
};

typedef NS_ENUM(NSInteger, NAHTTPRequestType) {
    NAHTTPRequestTypeGet,
    NAHTTPRequestTypePost
};

@interface NAAPIModel : NSObject

@property (nonatomic, assign) NARequestURLType requestUrlType;
@property (nonatomic, assign) NAHTTPRequestType requestType;
@property (nonatomic, strong) NSArray *pathArr;
@property (nonatomic, strong) NSMutableDictionary *param;

/** 正确的code 如果无需检验code，则为nil */
@property (nonatomic, copy) NSString *rightCode;

@end
