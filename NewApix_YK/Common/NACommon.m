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
    NSString *token = @"";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"login"]) {
        token = [defaults objectForKey:@"login"];
    }
    else if ([defaults objectForKey:@"register"]) {
        token = [defaults objectForKey:@"register"];
    }
    return token;
}


+ (void)setToken:(NSString *)token {
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

@end
