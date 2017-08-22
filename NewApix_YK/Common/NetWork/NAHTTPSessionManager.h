//
//  NAHTTPSessionManager.h
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "NAURLCenter.h"

typedef void(^ReturnValueBlock)(NSDictionary *returnValue);
typedef void(^ProgressBlock)(NSProgress *uploadProgress);
typedef void(^ErrorCodeBlock)(NSString *code, NSString *msg);
typedef void(^FailureBlock)(NSError *error);
typedef void(^ConstructingBodyBlock)(id<AFMultipartFormData> formData);
typedef void(^NetWorkBlock)(BOOL netConnetState);


@interface NAHTTPSessionManager : AFHTTPSessionManager

/**
 初始化对象
 
 @return manager对象
 */
+ (instancetype)manager;

/**
 初始化单例对象

 @return manager对象
 */
+ (instancetype)sharedManager;



/**
 封装网络请求 get和基本的post都可以

 @param apiModel NAAPIModel对象
 @param progressBlock  progressBlock
 @param block 请求成功block，返回数据
 @param errorBlock 请求失败block，这种是网络请求正常，但返回数据不对
 @param failureBlock 请求失败block，这种是网络请求就失败了
 */
- (void)netRequestWithApiModel:(NAAPIModel *)apiModel
                      progress:(ProgressBlock)progressBlock
              returnValueBlock:(ReturnValueBlock)block
                errorCodeBlock:(ErrorCodeBlock)errorBlock
                  failureBlock:(FailureBlock)failureBlock;

///**
// 封装get请求
//
// @param requestURLString 请求url
// @param parameter 参数dict
// @param block 请求成功block，返回数据
// @param errorBlock 请求失败block，这种是网络请求正常，但返回数据不对
// @param failureBlock 请求失败block，这种是网络请求就失败了
// */
//- (void)netRequestGETWithRequestURL:(NSString *)requestURLString
//                          parameter:(NSMutableDictionary *)parameter
//                   returnValueBlock:(ReturnValueBlock)block
//                     errorCodeBlock:(ErrorCodeBlock)errorBlock
//                       failureBlock:(FailureBlock)failureBlock;
//


/**
 封装post请求

 @param requestURLString 请求url
 @param parameter 参数dict
 @param bodyBlock 上传文件block
 @param progressBlock progress
 @param block 请求成功block，返回数据
 @param errorBlock 请求失败block，这种是网络请求正常，但返回数据不对
 @param failureBlock 请求失败block，这种是网络请求就失败了
 */
- (void)netRequesPOSTWithRequestURL:(NSString *)requestURLString
                          parameter:(NSMutableDictionary *)parameter
              constructingBodyBlock:(ConstructingBodyBlock)bodyBlock
                           progress:(ProgressBlock)progressBlock
                   returnValueBlock:(ReturnValueBlock)block
                     errorCodeBlock:(ErrorCodeBlock)errorBlock
                       failureBlock:(FailureBlock)failureBlock;

@end
