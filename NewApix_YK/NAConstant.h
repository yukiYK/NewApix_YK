//
//  NAConstant.h
//  NewApix_YK
//
//  Created by APiX on 2017/8/8.
//  Copyright © 2017年 APiX. All rights reserved.
//


#ifndef NAConstant_h
#define NAConstant_h


// --------------------- 一些常量 -------------
// 对密码进行AES加密的key
static NSString * const kAESKey = @"WEfs12SEWQte3DSq23ttga/sdfw=Vrlp";
#pragma mark - <通用imageName>
static NSString * const kImageDefault = @"defaultImage";
static NSString * const kImageBackWhite = @"back_white";
static NSString * const kImageBackBlack = @"back_black";

#pragma mark - <NotificationName>
static NSString * const kNotificationNetChange = @"kNotificationNetChange";
//static NSString * const kNotificationNetChange = @"defaultImage";
//static NSString * const kNotificationNetChange = @"defaultImage";
//static NSString * const kNotificationNetChange = @"defaultImage";
//static NSString * const kNotificationNetChange = @"defaultImage";

#pragma mark - <UserDefault>
static NSString * const kUserDefaultsOnOff = @"kUserDefaultsOnOff";       // 审核开关
static NSString * const kUserDefaultsUserStatus = @"kUserDefaultsUserStatus"; // 用户状态
static NSString * const kUserDefaultsToken = @"kUserDefaultsToken";       // token
static NSString * const kUserDefaultsNick = @"kUserDefaultsNick";         // 昵称
static NSString * const kUserDefaultsAvatar = @"kUserDefaultsAvatar";     // 头像地址
static NSString * const kUserDefaultsIdNumber = @"kUserDefaultsIdNumber"; // 身份证号
static NSString * const kUserDefaultsPhone = @"kUserDefaultsPhone";       // 账号/手机号
static NSString * const kUserDefaultUniqueId = @"kUserDefaultUniqueId";   //unique_id
static NSString * const kUserDefaultTrustScore = @"kUserDefaultTrustScore";// 信用分数
static NSString * const kUserDefaultLocation = @"kUserDefaultLocation";    // 位置

#pragma mark - <KeyChain>
static NSString * const kKeyChain = @"com.heige.meixinlife";   // 应用程序keyChain的Key
// 下面是具体保存到keyChain的每个key
static NSString * const kKeyChainPassword = @"kKeyChainPassword";  // 密码


#pragma mark - <第三方的一些key>
static NSString * const kUMAppKey = @"5784cbb2e0f55ac55e000978";
static NSString * const kUMChannelID = @"App Store";
static NSString * const kMQAppKey = @"20b7d9bb2cbd59f895433bbbfd366a3d";
static NSString * const kUMShareAppKey = @"";
static NSString * const kShareQQAppKey = @"1105485759";
static NSString * const kShareWechatAppKey = @"wxfa01bd3730538e0c";
static NSString * const kShareWechatAppSecret = @"";



#pragma mark - <通用数字>
static CGFloat const kStatusBarH = 20.0;
static CGFloat const kNavBarH = 44.0;
static CGFloat const kTabBarH = 49.0;
static CGFloat const kCommonMargin = 15.0;




#endif /* NAConstant_h */
