//
//  NACommon.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NACommon.h"

/**
 公共类，用来放一些全局方法
 */
@interface NACommon ()

/** 上下拉刷新普通状态图片组 */
@property (nonatomic, strong) NSMutableArray *loadingNormalImages;
/** 上下拉刷新正在刷新状态图片组 */
@property (nonatomic, strong) NSMutableArray *loadingRefreshingImages;

@end



@implementation NACommon
#pragma mark - <初始化单例对象>
+ (instancetype)sharedCommon {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark - <Lazy Load>
- (NSMutableArray *)loadingNormalImages {
    if (!_loadingNormalImages) {
        _loadingNormalImages = [NSMutableArray array];
        for(int i=1; i<=20; i++) {
            UIImage *image = kGetImage(([NSString stringWithFormat:@"loading_%d", i]));
            [_loadingNormalImages addObject:image];
        }
    }
    return _loadingNormalImages;
}
- (NSMutableArray *)loadingRefreshingImages {
    if (!_loadingRefreshingImages) {
        _loadingRefreshingImages = [NSMutableArray array];
        // 刷新时出现的gif图 需要循环添加到数组
        for(int i=1; i<=20; i++) {
            UIImage *image = kGetImage(([NSString stringWithFormat:@"loading_%d",i]));
            [_loadingRefreshingImages addObject:image];
        }
    }
    return _loadingRefreshingImages;
}

#pragma mark - <Token>
+ (NSString *)getToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsToken];
}

+ (void)setToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kUserDefaultsToken];
}

+ (NSString *)getUniqueId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUniqueId];
}

+ (void)setUniqueId:(NSString *)uniqueId {
    [[NSUserDefaults standardUserDefaults] setObject:uniqueId forKey:kUserDefaultsUniqueId];
}

/** 是否是实际用户看到的版本，否则为审核版 */
+ (BOOL)isRealVersion {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsOnOff];
}
+ (void)setRealVersion:(BOOL)real {
    [[NSUserDefaults standardUserDefaults] setBool:real forKey:kUserDefaultsOnOff];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - <上下拉刷新 - mj_refresh>
- (MJRefreshGifHeader *)createMJRefreshGifHeaderWithTarget:(id)target action:(SEL)action {
    
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    UIImage *pulingImage = kGetImage(@"loading_begin_20");
    NSMutableArray *loadingPullingImages = [NSMutableArray arrayWithObjects:pulingImage, nil];
    [gifHeader setImages:loadingPullingImages forState:MJRefreshStatePulling];
    [gifHeader setImages:self.loadingNormalImages forState:MJRefreshStateIdle];
    [gifHeader setImages:self.loadingRefreshingImages forState:MJRefreshStateRefreshing];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    gifHeader.stateLabel.hidden = YES;
    return gifHeader;
}

- (MJRefreshAutoGifFooter *)createMJRefreshAutoGifFooterWithTarget:(id)target action:(SEL)action {
    
    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:target refreshingAction:action];
    UIImage *pulingImage = kGetImage(@"loading_begin_20");
    NSMutableArray *loadingPullingImages = [NSMutableArray arrayWithObjects:pulingImage, nil];
    [gifFooter setImages:self.loadingNormalImages forState:MJRefreshStateIdle];
    [gifFooter setImages:loadingPullingImages forState:MJRefreshStatePulling];
    [gifFooter setImages:self.loadingRefreshingImages forState:MJRefreshStateRefreshing];
    gifFooter.refreshingTitleHidden = YES;
    return gifFooter;
}

/** 生成无更多数据footer */
- (UIView *)createNoMoreDataFooterView {
    
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    UILabel *creditFootLabel = [[UILabel alloc]init];
    creditFootLabel.textColor = [UIColor colorFromString:@"999999"];
    creditFootLabel.font = [UIFont systemFontOfSize:10];
    creditFootLabel.frame = CGRectMake(0, 30, kScreenWidth, 35);
    creditFootLabel.text = @"已经到底了，别扯了╮(╯▽╰)╭";
    footerView.backgroundColor = [UIColor clearColor];
    creditFootLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:creditFootLabel];
    
    return footerView;
}

- (NAUserStatus)userStatus {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsUserStatus];
}
- (void)setUserStatus:(NAUserStatus)userStatus {
    [[NSUserDefaults standardUserDefaults] setInteger:userStatus forKey:kUserDefaultsUserStatus];
}

+ (void)loadUserStatusComplete:(LoadCompleteBlock)block {
    
    NSString *token = [NACommon getToken];
    if(!token){
        [[NSUserDefaults standardUserDefaults] setInteger:NAUserStatusNoLogin forKey:kUserDefaultsUserStatus];
        if (block) {
            block(NAUserStatusNoLogin);
        }
        return;
    }
    
    // 从后台获取用户状态
    NAAPIModel *model = [NAURLCenter mineVipInfoConfig];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager sharedManager];
    [manager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@",returnValue);
        if([returnValue[@"apix_login_code"] intValue] == -1) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:NAUserStatusLoginError forKey:kUserDefaultsUserStatus];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsToken];
            if (block) {
                block(NAUserStatusLoginError);
            }
        }
        NSDictionary *dict = returnValue;
        NSNumber *code = dict[@"code"];
        
        if([code isEqualToNumber:@(0)]) {
            
            NSNumber *num = dict[@"data"][0][@"status"];
            //0是会员  2会员过期
            //-1 非会员
            if([num isEqualToNumber:@(2)]) {
                // 会员已到期"
                [[NSUserDefaults standardUserDefaults] setInteger:NAUserStatusOverdue forKey:kUserDefaultsUserStatus];
                if (block) {
                    block(NAUserStatusOverdue);
                }
            }else{
                // V会员
                [[NSUserDefaults standardUserDefaults] setInteger:NAUserStatusVIP forKey:kUserDefaultsUserStatus];
                if (block) {
                    block(NAUserStatusVIP);
                }
            }
        }else if ([code isEqualToNumber:@(-1)]) {
            // 暂未开通V会员";
            [[NSUserDefaults standardUserDefaults] setInteger:NAUserStatusNormal forKey:kUserDefaultsUserStatus];
            if (block) {
                block(NAUserStatusNormal);
            }
        }
        else {
            [[NSUserDefaults standardUserDefaults] setInteger:NAUserStatusNormal forKey:kUserDefaultsUserStatus];
            if (block) {
                block(NAUserStatusNormal);
            }
        }
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        [[NSUserDefaults standardUserDefaults] setInteger:NAUserStatusNormal forKey:kUserDefaultsUserStatus];
        if (block) {
            block(NAUserStatusNormal);
        }
    } failureBlock:^(NSError *error) {
        [[NSUserDefaults standardUserDefaults] setInteger:NAUserStatusNormal forKey:kUserDefaultsUserStatus];
        if (block) {
            block(NAUserStatusNormal);
        }
    }];
}

@end
