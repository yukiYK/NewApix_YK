//
//  NAIDCameraGuiderView.m
//  NewApix_YK
//
//  Created by APiX on 2017/10/26.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAIDCameraGuiderView.h"

@interface NAIDCameraGuiderView ()



@end

@implementation NAIDCameraGuiderView

+ (instancetype)sharedView {
    static dispatch_once_t once;
    static NAIDCameraGuiderView *instance;
    dispatch_once(&once, ^{
        instance = [[NAIDCameraGuiderView alloc] init];
    });
    return instance;
}

//- (instancetype)init {
//
//}

@end
