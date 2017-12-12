//
//  NABookAuthenticationController.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/12/11.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NABookAuthenticationController.h"
#import <Contacts/Contacts.h>
#import <AESCrypt/AESCrypt.h>

@interface NABookAuthenticationController ()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (nonatomic, strong) UIView *alertTipsView;

@property (nonatomic, strong) UIView *protocolView;

@property (nonatomic, strong) CNContactStore *store;

@property (nonatomic, strong) NSMutableArray *linkManArr;

@end

@implementation NABookAuthenticationController
#pragma mark - <Lazy Load>
- (NSMutableArray *)linkManArr {
    if (!_linkManArr) {
        _linkManArr = [NSMutableArray array];
    }
    return _linkManArr;
}

- (UIView *)alertTipsView {
    if (!_alertTipsView) {
        _alertTipsView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _alertTipsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 60 * 2, 260)];
        mainView.layer.masksToBounds = YES;
        mainView.layer.cornerRadius = 8;
        [_alertTipsView addSubview:mainView];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 30, mainView.width-50, 40)];
        tipLabel.font = [UIFont systemFontOfSize:16];
        tipLabel.textColor = [UIColor colorFromString:@"666666"];
        tipLabel.numberOfLines = 3;
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"稍后系统会弹出提示:‘允许通讯录授权’请点击‘同意’"];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"‘允许通讯录授权’"].location, [[noteStr string] rangeOfString:@"‘允许通讯录授权’"].length);
        NSRange redRange2 = NSMakeRange([[noteStr string] rangeOfString:@"‘同意’"].location, [[noteStr string] rangeOfString:@"‘同意’"].length);
        [noteStr addAttribute:NSForegroundColorAttributeName value:kColorLightBlue range:redRange];
        [noteStr addAttribute:NSForegroundColorAttributeName value:kColorLightBlue range:redRange2];
        [tipLabel setAttributedText:noteStr];
        
        UILabel* noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,CGRectGetMaxY(tipLabel.frame), mainView.width-50, 90)];
        noteLabel.font = [UIFont systemFontOfSize:14];
        noteLabel.textColor = [UIColor colorFromString:@"666666"];
        noteLabel.numberOfLines = 4;
        
        NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:@"若未出现弹窗,请自行进入手机的设置-隐私-通讯录-美信生活中打开权限,再次点击此按钮"];
        NSRange redRange1 = NSMakeRange([[noteStr1 string] rangeOfString:@"设置-隐私-通讯录-美信生活"].location, [[noteStr1 string] rangeOfString:@"设置-隐私-通讯录-美信生活"].length);
        [noteStr1 addAttribute:NSForegroundColorAttributeName value:kColorLightBlue range:redRange1];
        [noteLabel setAttributedText:noteStr1];
        
        [mainView addSubview:tipLabel];
        [mainView addSubview:noteLabel];
        
        UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, mainView.height - 50, mainView.width, 50)];
        [okBtn setBackgroundColor:kColorLightBlue];
        [okBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(onOKBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:okBtn];
        
        mainView.center = self.view.center;
    }
    return _alertTipsView;
}

- (UIView *)protocolView {
    if (!_protocolView) {
        _protocolView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _protocolView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissProtocol)];
        [_protocolView addGestureRecognizer:tapGes];
        
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.3, kScreenHeight * 0.3, kScreenWidth * 0.4, kScreenHeight * 0.4)];
        [_protocolView addSubview:mainView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, mainView.width, 30)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"通讯录授权协议";
        label.textAlignment = NSTextAlignmentCenter;
        [mainView addSubview:label];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 5, mainView.width, mainView.height - 5 - label.height - 8)];
        [mainView addSubview:scrollView];
        
        UIImage *image = kGetImage(@"book_protocol");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, image.size.height * scrollView.width / image.size.width)];
        imageView.image = image;
        [scrollView addSubview:imageView];
        scrollView.contentSize = CGSizeMake(scrollView.width, imageView.height);
    }
    return _protocolView;
}

#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"通讯录认证";
    [self setupSubviews];
}

- (void)setupSubviews {
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"授权过程中，如果提示您更改通讯录设置,请进入手机的设置-隐私-通讯录-美信生活中打开权限,返回美信生活客户端再重新进行授权"];
    NSRange range = NSMakeRange([[noteStr string] rangeOfString:@"设置-隐私-通讯录-美信生活"].location, [[noteStr string] rangeOfString:@"设置-隐私-通讯录-美信生活"].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:kColorLightBlue range:range];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [noteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [noteStr length])];
    self.tipsLabel.attributedText = noteStr;
}

- (void)bookAuthorization {
    //授权
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    //如果没有授权过需要请求用户的授权
    CNContactStore *store = [[CNContactStore alloc]init];
    self.store = store;
    
    if (status == CNAuthorizationStatusNotDetermined) {
        //请求授权
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"授权成功!");
            } else {
                NSLog(@"授权失败!");
            }
        }];
    }
    
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactGivenNameKey,CNContactPhoneNumbersKey,CNContactFamilyNameKey]];
    
    //参数1  封装查询请求
    [self.store enumerateContactsWithFetchRequest: request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        //返回的数据 CNContact
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[`~!@#$%^&*()+=|{}':《》<<>>;',//[//].<>/?~！@#￥%……&*（）——+|{}【】‘；：\"”“’。，、？] "];
        NSLog(@"%@",contact.givenName);
        NSLog(@"%@",contact.phoneNumbers);
        for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
            CNPhoneNumber *number = labeledValue.value;
            NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            NSString *name = [[nameStr componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
            NSLog(@"phone: %@", number.stringValue);
            NSString *phone = number.stringValue;
            NSLog(@"%@====%@",name,nameStr);
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            [dictM setValue:phone forKey:@"contact_phone"];
            [dictM setValue:name forKey:@"name"];
            [dictM setValue:@"1" forKey:@"source"];
            [dictM setValue:@"0000" forKey:@"created_at"];
            
            [self.linkManArr addObject:dictM];
        }
    }];
    [self requestForBookAuthorization];
}


#pragma mark - <Net Request>
- (void)requestForBookAuthorization {
    
    NSString *linkmenStr = [self convertArrayToString:self.linkManArr];
    NSLog(@"%@",linkmenStr);
    linkmenStr = [AESCrypt encrypt:linkmenStr password:kAESKey];
    NAAPIModel *model = [NAURLCenter bookAuthenticationConfigWithPhone:[NAUserTool getPhoneNumber] linkMenStr:linkmenStr];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        NSDictionary *data = returnValue[@"data"] ? returnValue[@"data"] : [NSDictionary dictionary];
        if (data.count > 0) {
            NSString *token = [NSString stringWithFormat:@"%@", data[@"token"]];
            [weakSelf requestForAuthenticationSave:token];
        } else {
            [SVProgressHUD showErrorWithStatus:@"认证失败，请稍后再试"];
        }
    } errorCodeBlock:nil failureBlock:nil];
}

- (void)requestForAuthenticationSave:(NSString *)token {
    NAAPIModel *model = [NAURLCenter authenticationSaveConfigWithStep:@"2" token:token];
    
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        [SVProgressHUD showSuccessWithStatus:@"认证成功，每月可更新认证一次"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } errorCodeBlock:nil failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
    }];
}

#pragma mark - <Events>
- (IBAction)onAgreeBtnClicked:(id)sender {
    self.agreeBtn.selected = !self.agreeBtn.selected;
}

- (IBAction)onProtocolBtnClicked:(id)sender {
    self.protocolView.alpha = 1.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.protocolView];
}

- (IBAction)onAuthorizationBtnClicked:(id)sender {
    self.alertTipsView.alpha = 1.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertTipsView];
}

- (void)onOKBtnClicked {
    [UIView animateWithDuration:0.8 animations:^{
        self.alertTipsView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.alertTipsView removeFromSuperview];
    }];
    
    [SVProgressHUD showWithStatus:@"授权中请保存网络畅通"];
}

- (void)dismissProtocol {
    [UIView animateWithDuration:0.8 animations:^{
        self.protocolView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.protocolView removeFromSuperview];
    }];
}

#pragma mark - <Method>
//将一个数组转化成字符串,改数组只能存储NSDictionary
- (NSString *)convertArrayToString:(NSArray *)array {
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendFormat:@"["];
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dict = array[i];
        //如果不是字典，跳过
        if (![dict isKindOfClass:[NSDictionary class]]) continue;
        NSString *dictString = [self convertDictToString:dict];
        [stringM appendString:dictString];
        if (i != array.count - 1) {
            [stringM appendString:@","];
        }
    }
    [stringM appendFormat:@"]"];
    return stringM.copy;
}

//将一个字段转化成字符串
- (NSString *)convertDictToString:(NSDictionary *)dict {
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendFormat:@"\"{"];
    [dict enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        if (![key isEqualToString:@"source"]) {
            [stringM appendFormat:@"'%@':'%@'",key,value];
        } else {
            [stringM appendFormat:@"'%@':%@",key,value];
        }
        
        if ([key isEqualToString:@"created_at"]) {
        } else {
            [stringM appendString:@","];
        }
    }];
    [stringM appendFormat:@"}\""];
    return stringM.copy;
}

@end
