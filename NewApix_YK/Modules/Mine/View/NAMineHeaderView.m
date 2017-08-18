//
//  NAMineHeaderView.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/18.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAMineHeaderView.h"

CGFloat const kTopViewHeight = 78.0;
CGFloat const kTopViewHeightV = 218.0;
CGFloat const kBottomViewHeight = 89.0;
CGFloat const kAvatarWidth = 48.0;
CGFloat const kVipIconWidth = 15.0;

@interface NAMineHeaderView ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *vipIcon;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *checkLabel;
@property (nonatomic, strong) UILabel *vipDateLabel;

@property (nonatomic, strong) UILabel *redPoint1;
@property (nonatomic, strong) UILabel *redPoint2;
@property (nonatomic, strong) UILabel *redPoint3;
@property (nonatomic, strong) UILabel *redPoint4;

@end

@implementation NAMineHeaderView

- (instancetype)initWithUserStatus:(NAUserStatus)userStatus {
    if (self = [super init]) {
        [self setupSubviewsWithUserStatus:userStatus];
    }
    return self;
}

- (void)setupSubviewsWithUserStatus:(NAUserStatus)userStatus {
    
    CGFloat topH = userStatus == NAUserStatusVIP ? kTopViewHeightV : kTopViewHeight;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topH)];
    [self addSubview:topView];
    
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCommonMargin, kCommonMargin, kAvatarWidth, kAvatarWidth)];
    avatarImageView.layer.cornerRadius = 3;
    avatarImageView.layer.masksToBounds = YES;
    [topView addSubview:avatarImageView];
    self.avatarImageView = avatarImageView;
    
    UIImageView *vipIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) - kVipIconWidth, CGRectGetMaxY(avatarImageView.frame) - kVipIconWidth, kVipIconWidth, kVipIconWidth)];
    vipIcon.image = kGetImage(@"mine_icon_novip");
    [topView addSubview:vipIcon];
    self.vipIcon = vipIcon;
    
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 20, (kAvatarWidth - 18)/2, 150, 18)];
    nickLabel.font = [UIFont systemFontOfSize:14];
    nickLabel.text = @"昵称";
    [topView addSubview:nickLabel];
    self.nickLabel = nickLabel;
    
    UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickLabel.frame) + 8, nickLabel.frame.origin.y, 100, 18)];
    checkLabel.layer.masksToBounds = YES;
    checkLabel.layer.cornerRadius = 10;
    checkLabel.layer.borderWidth = 1;
    checkLabel.layer.borderColor = kColorLightBlue.CGColor;
    checkLabel.textColor = kColorLightBlue;
    [topView addSubview:checkLabel];
    self.checkLabel = checkLabel;
    
    
    if ([NACommon isRealVersion]) {
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), kScreenWidth, kCommonMargin)];
        centerView.backgroundColor = kColorHeaderGray;
        [self addSubview:centerView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(centerView.frame), kScreenWidth, kBottomViewHeight)];
        [self addSubview:bottomView];
    }
}

@end
