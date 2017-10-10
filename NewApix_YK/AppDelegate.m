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
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "sys/utsname.h"

@interface AppDelegate ()

@property (nonatomic, assign) AFNetworkReachabilityStatus netStatus;

@end

@implementation AppDelegate

#pragma mark - <Application Life Cycle>
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
    [self setupSVProgressHUD];
    
    // 获取uuid
    [self setupDeviceInfo];
    
    // 监听网络状态变化
//    AFNetworkReachabilityManager
    self.netStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    // 设置IQKeyboardManager
    [self setupIQKeyboardManager];
    // iOS11适配
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
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
    
    NAAPIModel *model = [NAURLCenter onOrOffConfigWithName:[NSString stringWithFormat:@"version%@", VERSION] origin:@"1"];
    
    [[NAHTTPSessionManager sharedManager] netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        if ([returnValue[@"switch"] integerValue] == 1) {
            [NACommon setRealVersion:YES];
        }
        else if ([returnValue[@"switch"] integerValue] == 0) {
            [NACommon setRealVersion:YES];
        }
        // 获取用户状态后设置真正的根视图
        [NACommon loadUserStatusComplete:^(NAUserStatus userStatus) {
            NATabbarController *tabbarC = [[NATabbarController alloc] init];
            self.window.rootViewController = tabbarC;
            [self.window makeKeyAndVisible];
        }];
    } errorCodeBlock:^(NSString *code, NSString *msg) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

/** 配置各个分享平台 */
- (void)configUSharePlatforms {
    
    // 微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kShareWechatAppKey appSecret:kShareWechatAppSecret redirectURL:SERVER_ADDRESS_H5];
    
    // QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kShareQQAppKey appSecret:nil redirectURL:SERVER_ADDRESS_H5];
}

- (void)setupSVProgressHUD {
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:57.0/255.0 green:57.0/255.0 blue:57.0/255.0 alpha:.9]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0]];
}

- (void)setupDeviceInfo {
    NSString *uuid;
    if (![NAKeyChain loadKeyChainWithKey:kKeyChainUuid]) {
        uuid = [[NSUUID UUID] UUIDString];
        [NAKeyChain saveKeyChainValue:uuid key:kKeyChainUuid];
    }else{
        uuid = [NAKeyChain loadKeyChainWithKey:kKeyChainUuid];
    }
    [NAUserTool saveDeviceId:uuid];
    NSString *systemDesc = [NSString stringWithFormat:@"%@%@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    [NAUserTool saveSystemVersion:systemDesc];
    NSString *equipmentType = [self deviceString];
    [NAUserTool saveEquipmentType:equipmentType];
}

//查看当前机型
- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    if ([deviceString isEqualToString:@"iPhone5,1"]||[deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]||[deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString hasPrefix:@"iPhone6"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    return deviceString;
}

- (void)setupIQKeyboardManager {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
//    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:@"确定"];
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
