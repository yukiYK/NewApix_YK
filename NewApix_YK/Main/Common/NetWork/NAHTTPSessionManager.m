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

- (void)netRequestGETWithRequestURL:(NSString *)requestURLString
                          parameter:(NSMutableDictionary *)parameter
                   returnValueBlock:(ReturnValueBlock)block
                     errorCodeBlock:(ErrorCodeBlock)errorBlock
                       failureBlock:(FailureBlock)failureBlock {
    
    [self GET:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *ret = [NSString stringWithFormat:@"%@",responseObject[@"ret"]];
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            NSDictionary *data = responseObject[@"data"];
            
            NSLog(@"ret: %@",ret);
            NSLog(@"code: %@",code);
            
            if ([ret isEqualToString:@"0"] && [code isEqualToString:@"0"]) {
                
                block(data);
            }
            else {
                NSString *message = [NSString stringWithFormat:@"%@", msg];
                errorBlock(ret, code, message);
            }
        }
        else {
            block(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
        NSLog(@"%@",error);
    }];
    
}

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
                NSString *ret = [NSString stringWithFormat:@"%@",responseObject[@"ret"]];
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                NSDictionary *data = responseObject[@"data"];
                
                NSLog(@"ret: %@",ret);
                NSLog(@"code: %@",code);
                
                if ([ret isEqualToString:@"0"] && [code isEqualToString:@"0"]) {
                    
                    block(data);
                }
                else {
                    NSString *message = [NSString stringWithFormat:@"%@", msg];
                    errorBlock(ret, code, message);
                }
            }
            else {
                block(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
            NSLog(@"%@",error);
        }];
        
    }
    else {
        [self POST:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            progressBlock(uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *ret = [NSString stringWithFormat:@"%@",responseObject[@"ret"]];
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                NSDictionary *data = responseObject[@"data"];
                
                NSLog(@"ret: %@",ret);
                NSLog(@"code: %@",code);
                
                if ([ret isEqualToString:@"0"] && [code isEqualToString:@"0"]) {
                    
                    block(data);
                }
                else {
                    NSString *message = [NSString stringWithFormat:@"%@", msg];
                    errorBlock(ret, code, message);
                }
            }
            else {
                block(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
            NSLog(@"%@",error);
        }];
    }
}


@end
