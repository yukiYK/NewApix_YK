//
//  AppDelegate.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/26.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "AppDelegate.h"
#import "NATabbarController.h"
#import <MeiQiaSDK/MQManager.h>
#import <UMSocialCore/UMSocialCore.h>

@interface AppDelegate ()

@property (nonatomic, assign) AFNetworkReachabilityStatus netStatus;

@end

@implementation AppDelegate

#pragma mark - <Application Methods>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置根视图
    // 先设置一个假的根视图，用于请求审核开关
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    UIViewController *vc = [[UIViewController alloc] init];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:vc.view.bounds];
    imgView.image = kGetImage(@"launch_image");
    [vc.view addSubview:imgView];
    window.rootViewController = vc;
    
    self.window = window;
    [self.window makeKeyAndVisible];
    
    // 延时设置真正的根视图
    // 审核开关
    [NACommon setRealVersion:YES];
    [self loadOnOff];
    
    // 初始化第三方的工具
    [self initUMeng];
    
    [self initMeiQia];
    
    // 监听网络状态变化
//    AFNetworkReachabilityManager
    self.netStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// App 进入后台时
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 关闭美洽服务
    [MQManager closeMeiqiaService];
}

// App 即将进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    // 开启美洽服务
    [MQManager openMeiqiaService];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [MQManager registerDeviceToken:deviceToken];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    
    if (result == FALSE) {
        NSLog(@"------------");
    }
    
    return result;
}



#pragma mark - <Custom Methods>
/** 初始化友盟 */
- (void)initUMeng {
    // 初始化友盟统计
    UMConfigInstance.appKey = kUMAppKey;
    UMConfigInstance.channelId = kUMChannelID;
    [MobClick startWithConfigure:UMConfigInstance];
    
    // 初始化友盟分享
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMShareAppKey];
    
    [self configUSharePlatforms];
    
    // 初始化友盟推送
}

/** 初始化美洽 */
- (void)initMeiQia {
    
    [MQManager initWithAppkey:kMQAppKey completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽SDK：初始化成功");
        }
        else {
            NSLog(@"美洽SDK：初始化失败 error：%@", error);
        }
    }];
    
}

/** 审核开关 */
- (void)loadOnOff {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSLog(@"%@", VERSION);
    param[@"name"] = [NSString stringWithFormat:@"version%@", VERSION];
    param[@"origin"] = @"1";
    
    [[NAHTTPSessionManager sharedManager] netRequestGETWithRequestURL:[NAHTTPSessionManager urlWithType:NARequestURLTypeAPI pathArray:@[@"api", @"control"]] parameter:param returnValueBlock:^(NSDictionary *returnValue) {
        if ([returnValue[@"switch"] integerValue] == 1) {
            [NACommon setRealVersion:YES];
        }
        else if ([returnValue[@"switch"] integerValue] == 0) {
            [NACommon setRealVersion:NO];
        }
        // 获取用户状态后设置真正的根视图
        [NACommon loadUserStatusComplete:^(NAUserStatus userStatus) {
            NATabbarController *tabbarC = [[NATabbarController alloc] init];
            self.window.rootViewController = tabbarC;
            [self.window makeKeyAndVisible];
        }];
        
    } errorCodeBlock:nil failureBlock:nil];
}

/** 配置各个分享平台 */
- (void)configUSharePlatforms {
    
    // 微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kShareWechatAppKey appSecret:kShareWechatAppSecret redirectURL:SERVER_ADDRESS_H5];
    
    // QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kShareQQAppKey appSecret:nil redirectURL:SERVER_ADDRESS_H5];
}


/** 监听到网络变化 */
- (void)reachabilityChanged {
    AFNetworkReachabilityStatus currentNetStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (self.netStatus == AFNetworkReachabilityStatusNotReachable && currentNetStatus != AFNetworkReachabilityStatusNotReachable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetChange object:nil];
    }
    self.netStatus = currentNetStatus;
}

@end
