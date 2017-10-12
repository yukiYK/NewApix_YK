//
//  NAHTTPSessionManager.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAHTTPSessionManager.h"

@implementation NAHTTPSessionManager

+ (instancetype)manager {
    NAHTTPSessionManager *manager = [super manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
//    @"application/json"
    manager.requestSerializer.timeoutInterval = 15;
    manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    manager.requestSerializer.HTTPShouldHandleCookies = NO;
    manager.requestSerializer.HTTPShouldUsePipelining = YES;
    return manager;
}

+ (instancetype)sharedManager {
    static NAHTTPSessionManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super manager];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html",nil];
        instance.requestSerializer.timeoutInterval = 15;
        instance.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        instance.requestSerializer.HTTPShouldHandleCookies = NO;
        instance.requestSerializer.HTTPShouldUsePipelining = YES;
    });
    return instance;
}

/**
 为post请求更改配置
 */
- (void)setRequestSerializerForPost {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer setValue:[NAUserTool getDeviceId] forHTTPHeaderField:@"deviceid"];
    [self.requestSerializer setValue:[NAUserTool getSystemVersion] forHTTPHeaderField:@"systemversion"];
    [self.requestSerializer setValue:[NAUserTool getEquipmentType] forHTTPHeaderField:@"equipmenttype"];
}


/**
 封装网络请求
 
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
                  failureBlock:(FailureBlock)failureBlock {
    
    NSString *urlStr = [NAURLCenter urlWithType:apiModel.requestUrlType pathArray:apiModel.pathArr];
    if (apiModel.requestType == NAHTTPRequestTypeGet) {
        
        [self GET:urlStr parameters:apiModel.param progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progressBlock) {
                progressBlock(downloadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (!apiModel.rightCode) {
                    if (block) block(responseObject);
                }
                else {
                    NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                    NSLog(@"code: %@",code);
                    
                    if ([code isEqualToString:apiModel.rightCode]) {
                        
                        if (block) block(responseObject);
                    }
                    else {
                        NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                        if (!msg) {
                            msg = @"请求失败";
                        }
                        if (errorBlock) errorBlock(code, msg);
                    }
                }
            }
            else {
                NSLog(@"返回数据格式不对");
                if (block) block(nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) failureBlock(error);
            NSLog(@"%@",error);
        }];
    }
    else if (apiModel.requestType == NAHTTPRequestTypePost) {
        [self POST:urlStr parameters:apiModel.param progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progressBlock) {
                progressBlock(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                if (!apiModel.rightCode) {
                    if (block) block(responseObject);
                }
                else {
                    //                NSString *ret = [NSString stringWithFormat:@"%@",responseObject[@"ret"]];
                    NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                    NSLog(@"code: %@",code);
                    
                    if ([code isEqualToString:apiModel.rightCode]) {
                        
                        if (block) block(responseObject);
                    }
                    else {
                        NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                        if (!msg) {
                            msg = @"请求失败";
                        }
                        if (errorBlock) errorBlock(code, msg);
                    }
                }
            }
            else {
                if (block) block(nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) failureBlock(error);
            NSLog(@"%@",error);
        }];
    }
}

/**
 封装get请求
 
 @param requestURLString 请求url
 @param parameter 参数dict
 @param block 请求成功block，返回数据
 @param errorBlock 请求失败block，这种是网络请求正常，但返回数据不对
 @param failureBlock 请求失败block，这种是网络请求就失败了
 */
//- (void)netRequestGETWithRequestURL:(NSString *)requestURLString
//                          parameter:(NSMutableDictionary *)parameter
//                   returnValueBlock:(ReturnValueBlock)block
//                     errorCodeBlock:(ErrorCodeBlock)errorBlock
//                       failureBlock:(FailureBlock)failureBlock {
//    
//    [self GET:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//            NSString *msg = @"请求失败";//[NSString stringWithFormat:@"%@",responseObject[@"msg"]];
//            
//            NSLog(@"code: %@",code);
//            
//            if ([code isEqualToString:@"0"]) {
//                
//                if (block) block(responseObject);
//            }
//            else {
//                NSString *message = [NSString stringWithFormat:@"%@", msg];
//                if (errorBlock) errorBlock(code, message);
//            }
//        }
//        else {
//            if (block) block(responseObject);
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failureBlock) failureBlock(error);
//        NSLog(@"%@",error);
//    }];
//}

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
                       failureBlock:(FailureBlock)failureBlock {
    
    if (bodyBlock) {
        
        [self POST:requestURLString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            bodyBlock(formData);
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progressBlock) {
                progressBlock(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                NSString *msg = @"请求失败";//[NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                
                NSLog(@"code: %@",code);
                
                if ([code isEqualToString:@"0"]) {
                    
                    if (block) block(responseObject);
                }
                else {
                    NSString *message = [NSString stringWithFormat:@"%@", msg];
                    if (errorBlock) errorBlock(code, message);
                }
            }
            else {
                if (block) block(nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) failureBlock(error);
            NSLog(@"%@",error);
        }];
        
    }
    else {
        [self POST:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progressBlock) {
                progressBlock(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                NSString *ret = [NSString stringWithFormat:@"%@",responseObject[@"ret"]];
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                NSString *msg = @"请求失败"; //[NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                
                NSLog(@"code: %@",code);
                
                if ([code isEqualToString:@"0"]) {
                    
                    if (block) block(responseObject);
                }
                else {
                    NSString *message = [NSString stringWithFormat:@"%@", msg];
                    if (errorBlock) errorBlock(code, message);
                }
            }
            else {
                if (block) block(nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) failureBlock(error);
            NSLog(@"%@",error);
        }];
    }
}


@end
