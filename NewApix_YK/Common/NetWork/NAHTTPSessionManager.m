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
    //@"application/json"
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
    return urlString;
}

/**
 封装get请求
 
 @param requestURLString 请求url
 @param parameter 参数dict
 @param block 请求成功block，返回数据
 @param errorBlock 请求失败block，这种是网络请求正常，但返回数据不对
 @param failureBlock 请求失败block，这种是网络请求就失败了
 */
- (void)netRequestGETWithRequestURL:(NSString *)requestURLString
                          parameter:(NSMutableDictionary *)parameter
                   returnValueBlock:(ReturnValueBlock)block
                     errorCodeBlock:(ErrorCodeBlock)errorBlock
                       failureBlock:(FailureBlock)failureBlock {
    
    [self GET:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
            if (block) block(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) failureBlock(error);
        NSLog(@"%@",error);
    }];
    
}

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
            progressBlock(uploadProgress);
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
                if (block) block(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) failureBlock(error);
            NSLog(@"%@",error);
        }];
        
    }
    else {
        [self POST:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            progressBlock(uploadProgress);
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
                if (block) block(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) failureBlock(error);
            NSLog(@"%@",error);
        }];
    }
}


@end
