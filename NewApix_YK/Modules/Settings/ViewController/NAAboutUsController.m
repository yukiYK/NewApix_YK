//
//  NAAboutUsController.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/30.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAAboutUsController.h"

@interface NAAboutUsController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UIView *servicePhoneView;


@end

@implementation NAAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"关于我们";
    [self setupSubviews];
}

- (void)setupSubviews {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"%@ 版本%@", appName, appVersion];
    
    UITapGestureRecognizer *scoreTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScore)];
    [self.scoreView addGestureRecognizer:scoreTapGes];
    
    UITapGestureRecognizer *serviceTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapService)];
    [self.servicePhoneView addGestureRecognizer:serviceTapGes];
}

- (void)tapScore {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/apple-store/id1145747357"]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)tapService {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定呼叫400-9699-029吗?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //拨打电话
        [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:@"tel://4009699029"]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
