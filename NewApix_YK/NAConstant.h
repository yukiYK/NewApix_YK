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
// 内购商品
static NSString * const kProductVipMonth = @"com.heige.meixinlife23";
static NSString * const kProductVipLifelong = @"com.heige.meixinlife24";
#pragma mark - <通用imageName>
static NSString * const kImageDefault = @"defaultImage";
static NSString * const kImageAvatarDefault = @"avatar_default";
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
// 用户信息
static NSString * const kUserDefaultsNick = @"kUserDefaultsNick";         // 昵称
static NSString * const kUserDefaultsAvatar = @"kUserDefaultsAvatar";     // 头像地址
static NSString * const kUserDefaultsIdName = @"kUserDefaultsIdName";     // 身份证上的姓名
static NSString * const kUserDefaultsIdNumber = @"kUserDefaultsIdNumber"; // 身份证号
static NSString * const kUserDefaultsIdNation = @"kUserDefaultsIdNation";   // 身份证上的国籍
static NSString * const kUserDefaultsIdDetailedAddress = @"kUserDefaultsIdDetailedAddress";// 身份证上的详细地址
static NSString * const kUserDefaultsPhone = @"kUserDefaultsPhone";       // 用户手机号
static NSString * const kUserDefaultsTrustScore = @"kUserDefaultsTrustScore";// 信用分数
static NSString * const kUserDefaultsSex = @"kUserDefaultsSex";    // 性别

static NSString * const kUserDefaultsLoginPhone = @"kUserDefaultsLoginPhone"; // 登录页保存的账号
static NSString * const kUserDefaultsUniqueId = @"kUserDefaultsUniqueId";   //unique_id
static NSString * const kUserDefaultsLocation = @"kUserDefaultsLocation";    // 位置
static NSString * const kUserDefaultsDeviceId = @"kUserDefaultsDeviceId";    // deviceID
static NSString * const kUserDefaultsSystemVersion = @"kUserDefaultsSystemVersion";    // 系统版本
static NSString * const kUserDefaultsEquipmentType = @"kUserDefaultsEquipmentType";    // 设备类型

// --------------------------------------各种认证状态-----------------------------------------------
/** 身份认证 */
static NSString * const kUserDefaultsAuthenticationIDCard = @"kUserDefaultsAuthenticationIDCard";
/** 京东认证 */
static NSString * const kUserDefaultsAuthenticationJD = @"kUserDefaultsAuthenticationJD";
/** 淘宝认证 */
static NSString * const kUserDefaultsAuthenticationTB = @"kUserDefaultsAuthenticationTB";
/** 通讯录 */
static NSString * const kUserDefaultsAuthenticationAddressBook = @"kUserDefaultsAuthenticationAddressBook";
/** 运营商 */
static NSString * const kUserDefaultsAuthenticationService = @"kUserDefaultsAuthenticationService";
/** 借贷历史 */
static NSString * const kUserDefaultsAuthenticationLoan = @"kUserDefaultsAuthenticationLoan";
/** 基本信息 */
static NSString * const kUserDefaultsAuthenticationInfo = @"kUserDefaultsAuthenticationInfo";
/** 公积金 */
static NSString * const kUserDefaultsAuthenticationHouse = @"kUserDefaultsAuthenticationHouse";
/** 学信网 */
static NSString * const kUserDefaultsAuthenticationSchool = @"kUserDefaultsAuthenticationSchool";
/** 央行征信 */
static NSString * const kUserDefaultsAuthenticationCentralBank = @"kUserDefaultsAuthenticationCentralBank";
/** 芝麻认证 */
static NSString * const kUserDefaultsAuthenticationSesame = @"kUserDefaultsAuthenticationSesame";
/** 芝麻信用 */
static NSString * const kUserDefaultsAuthenticationSesameCredit = @"kUserDefaultsAuthenticationSesameCredit";

#pragma mark - <KeyChain>
static NSString * const kKeyChain = @"com.heige.meixinlife";   // 应用程序keyChain的Key
// 下面是具体保存到keyChain的每个key
static NSString * const kKeyChainPassword = @"kKeyChainPassword";  // 密码
static NSString * const kKeyChainUuid = @"kKeyChainUuid";    // uuid

#pragma mark - <第三方的一些key>
static NSString * const kUMAppKey = @"5784cbb2e0f55ac55e000978";
static NSString * const kUMChannelID = @"App Store";
static NSString * const kMQAppKey = @"20b7d9bb2cbd59f895433bbbfd366a3d";
static NSString * const kUMShareAppKey = @"";
static NSString * const kShareQQAppKey = @"1105485759";
static NSString * const kShareWechatAppKey = @"wxfa01bd3730538e0c";
static NSString * const kShareWechatAppSecret = @"";


#pragma mark - <认证需要的一些url和key>
static NSString * const kAuthenticationCallbackUrl = @"http://api.meixinlife.com/user/reset";
static NSString * const kAuthenticationSuccessUrl = @"https://api.meixinlife.com/api/success";
static NSString * const kAuthenticationFailedUrl = @"https://api.meixinlife.com/api/failed";
/** 淘宝认证 */
static NSString * const kTBUrl = @"http://e.apix.cn/apixanalysis/tb/grant/ele_business/taobao/pages";
static NSString * const kTBApixKey = @"cf8f4e5a3ff549767044877d387653a0";
/** 京东认证 */
static NSString * const kJDUrl = @"http://e.apix.cn/apixanalysis/jd/grant/ele_business/jingdong/jd/page";
static NSString * const kJDApixKey = @"038d8deabe654a687bbd5279127c2826";
/** 运营商认证 */
static NSString * const kServiceUrl = @"http://e.apix.cn/apixanalysis/mobile/yys/phone/carrier/page";
static NSString * const kServiceApixKey = @"ba287ff6c449411365ea2e0bcaca61b7";



#pragma mark - <通用数字>
static CGFloat const kNavBarH = 44.0;
static CGFloat const kCommonMargin = 15.0;




#endif /* NAConstant_h */
