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

@end

@implementation AppDelegate

#pragma mark - <Application Methods>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置根视图
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    NATabbarController *tabbarC = [[NATabbarController alloc] init];
    window.rootViewController = tabbarC;
    
    self.window = window;
    [self.window makeKeyAndVisible];
    
    // 初始化友盟
    UMConfigInstance.appKey = kUMAppKey;
    UMConfigInstance.channelId = kUMChannelID;
    [MobClick startWithConfigure:UMConfigInstance];
    
    // 初始化美洽
    [MQManager initWithAppkey:kMQAppKey completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽SDK：初始化成功");
        }
        else {
            NSLog(@"美洽SDK：初始化失败 error：%@", error);
        }
    }];
    
    // 初始化友盟分享
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMShareAppKey];
    
    [self configUSharePlatforms];
    
    // 初始化友盟推送
    
    
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
- (void)configUSharePlatforms {
    
    // 微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kShareWechatAppKey appSecret:kShareWechatAppSecret redirectURL:SERVER_ADDRESS_H5];
    
    // QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kShareQQAppKey appSecret:nil redirectURL:SERVER_ADDRESS_H5];
}


@end
