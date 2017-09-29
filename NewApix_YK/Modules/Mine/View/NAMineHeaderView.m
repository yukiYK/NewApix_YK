//
//  NAMineHeaderView.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/18.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAMineHeaderView.h"
#import "NSAttributedString+NAExtension.h"

CGFloat const kTopViewHeight = 78.0;
CGFloat const kTopViewHeightV = 218.0;
CGFloat const kBottomViewHeight = 89.0;
CGFloat const kAvatarWidth = 48.0;
CGFloat const kVipIconWidth = 15.0;
CGFloat const kBtnHeight = 44.0;
#define kBtnWidth kScreenWidth/4
CGFloat const kRedPointWidth = 13;

@interface NAMineHeaderView ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *vipIcon;
@property (nonatomic, strong) UIImageView *vipCardImageView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *checkLabel;
@property (nonatomic, strong) UILabel *vipDateLabel;

@property (nonatomic, strong) UIButton *redPoint1;
@property (nonatomic, strong) UIButton *redPoint2;
@property (nonatomic, strong) UIButton *redPoint3;
@property (nonatomic, strong) UIButton *redPoint4;

@property (nonatomic, assign) NAUserStatus userStatus;
@property (nonatomic, copy) OrderBtnsActionBlock actionBlock;

@end

@implementation NAMineHeaderView

- (instancetype)initWithUserStatus:(NAUserStatus)userStatus {
    if (self = [super init]) {
        [self setupSubviewsWithUserStatus:userStatus];
    }
    return self;
}

- (void)setupSubviewsWithUserStatus:(NAUserStatus)userStatus {
    _userStatus = userStatus;
    
    CGFloat topH = userStatus == NAUserStatusVIP ? kTopViewHeightV : kTopViewHeight;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topH)];
    [self addSubview:topView];
    
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCommonMargin, kCommonMargin, kAvatarWidth, kAvatarWidth)];
    avatarImageView.image = kGetImage(kImageAvatarDefault);
    avatarImageView.layer.cornerRadius = 3;
    avatarImageView.layer.masksToBounds = YES;
    [topView addSubview:avatarImageView];
    self.avatarImageView = avatarImageView;
    
    UIImageView *vipIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) - kVipIconWidth/2, CGRectGetMaxY(avatarImageView.frame) - kVipIconWidth/2, kVipIconWidth, kVipIconWidth)];
    vipIcon.image = kGetImage(@"mine_icon_novip");
    [topView addSubview:vipIcon];
    self.vipIcon = vipIcon;
    
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 20, (kAvatarWidth - 18)/2, 50, 18)];
    nickLabel.font = [UIFont systemFontOfSize:14];
    nickLabel.text = @"昵称";
    [topView addSubview:nickLabel];
    self.nickLabel = nickLabel;
    
    UILabel *checkLabel = [[UILabel alloc] init];
    checkLabel.layer.masksToBounds = YES;
    checkLabel.layer.cornerRadius = 9;
    checkLabel.layer.borderWidth = 1;
    checkLabel.layer.borderColor = kColorLightBlue.CGColor;
    checkLabel.textColor = kColorLightBlue;
    checkLabel.text = @"未认证";
    checkLabel.font = [UIFont systemFontOfSize:11];
    checkLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:checkLabel];
    self.checkLabel = checkLabel;
    [self.checkLabel sizeToFit];
    self.checkLabel.frame = CGRectMake(CGRectGetMaxX(_nickLabel.frame) + 8, _nickLabel.frame.origin.y, self.checkLabel.width + 10, 18);
    
    UILabel *vipDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickLabel.x, vipIcon.y, kScreenWidth - nickLabel.x - kCommonMargin, kVipIconWidth)];
    vipDateLabel.textColor = kColorTextYellow;
    vipDateLabel.font = [UIFont systemFontOfSize:12];
    [topView addSubview:vipDateLabel];
    self.vipDateLabel = vipDateLabel;
    
    if (userStatus == NAUserStatusVIP) {
        UIImageView *vipCardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCommonMargin, kTopViewHeight + 5, kScreenWidth - kCommonMargin * 2, kTopViewHeightV - kTopViewHeight)];
        [topView addSubview:vipCardImageView];
        self.vipCardImageView = vipCardImageView;
    }
    
    // 订单信息
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), kScreenWidth, 8)];
    centerView.backgroundColor = kColorHeaderGray;
    [self addSubview:centerView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(centerView.frame), kScreenWidth, kBottomViewHeight)];
    [self addSubview:bottomView];
    
    NSArray *titleArr = @[@"进行中", @"成功", @"退款", @"我的订单"];
    NSArray *imageArr = @[@"mine_loan_ing", @"mine_loan_succeed", @"mine_loan_back", @"mine_loan_order"];
    for (int i=0; i<4; i++) {
        UIButton *button = [self buttonWithTitle:titleArr[i] image:imageArr[i] tag:100 + i];
        [bottomView addSubview:button];
    }
    
    UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(kBtnWidth * 3 - 2.5, 0, 5, bottomView.height)];
    verticalLine.image = kGetImage(@"mine_vertical_line");
    [bottomView addSubview:verticalLine];
    
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(bottomView.frame));
}

- (UIButton *)buttonWithTitle:(NSString *)title image:(NSString *)imageName tag:(NSInteger)tag {
    
    NSInteger index = tag - 100;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kBtnWidth * index, kCommonMargin + 10, kBtnWidth, kBtnHeight)];
    //设置图文混排的按钮
    [button setAttributedTitle:[NSAttributedString attributedStringWithImage:kGetImage(imageName) imageWH:24 title:title fontSize:12 titleColor:[UIColor blackColor] spacing:12] forState:UIControlStateNormal];
    //按钮上的文字换行
    button.titleLabel.numberOfLines = 0;
    //按钮上的文字居中
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    //按钮自适应大小
//    [button sizeToFit];
    //添加点击事件
    [button addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    UIButton *redPoint = [[UIButton alloc] initWithFrame:CGRectMake(kBtnWidth/2 + 10, -kRedPointWidth/2, kRedPointWidth, kRedPointWidth)];
    [redPoint setBackgroundImage:kGetImage(@"badge") forState:UIControlStateNormal];
    [redPoint setTitle:@"12" forState:UIControlStateNormal];
    [redPoint.titleLabel setFont:[UIFont systemFontOfSize:9]];
    redPoint.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [redPoint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addSubview:redPoint];
    [self setValue:redPoint forKey:[NSString stringWithFormat:@"redPoint%ld",index + 1]];
    
    return button;
}

- (void)setUserInfo:(NAUserInfoModel *)userInfo {
    _userInfo = userInfo;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:kGetImage(kImageAvatarDefault)];
    self.nickLabel.text = userInfo.nick_name.length>0?userInfo.nick_name:@"昵称";
    [self.nickLabel sizeToFit];
    
    self.checkLabel.text = [userInfo.id_number checkEmpty]?@"未认证":@"已认证";
    [self.checkLabel sizeToFit];
    self.checkLabel.frame = CGRectMake(CGRectGetMaxX(_nickLabel.frame) + 8, _checkLabel.y, _checkLabel.width + 10, 18);
}

- (void)setOrderModel:(NAMineOrderModel *)orderModel actionBlock:(OrderBtnsActionBlock)actionBlock {
    if (![NACommon isRealVersion]) return;
    
    [self.redPoint1 setTitle:orderModel.transactions forState:UIControlStateNormal];
    [self.redPoint2 setTitle:orderModel.success forState:UIControlStateNormal];
    [self.redPoint3 setTitle:orderModel.refound forState:UIControlStateNormal];
    [self.redPoint4 setTitle:orderModel.paid forState:UIControlStateNormal];
    
    self.actionBlock = actionBlock;
}

- (void)setIsVip:(BOOL)isVip endDate:(NSString *)endDate vipCardUrl:(NSString *)vipCardUrl {
    if (![NACommon isRealVersion]) return;
    
    if (isVip) {
        self.vipIcon.image = kGetImage(@"mine_icon_vip");
        
        self.vipDateLabel.hidden = NO;
        self.vipDateLabel.text = [NSString stringWithFormat:@"会员有效期至%@", endDate];
        
        self.vipCardImageView.hidden = NO;
        [self.vipCardImageView sd_setImageWithURL:[NSURL URLWithString:vipCardUrl] placeholderImage:[kGetImage(kImageDefault) cutImageAdaptImageViewSize:self.vipCardImageView.bounds.size]];
    }
    else {
        self.vipIcon.image = kGetImage(@"mine_icon_novip");
        self.vipDateLabel.hidden = YES;
        self.vipCardImageView.hidden = YES;
    }
}

#pragma mark - <Events>
- (void)onBtnClicked:(UIButton *)button {
    if (self.actionBlock) {
        self.actionBlock(button.tag);
    }
}

@end
