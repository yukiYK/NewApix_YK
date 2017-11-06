//
//  NAShareView.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/6.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAShareView.h"

static CGFloat kShareMainViewH = 290;

@interface NAShareView ()

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, copy) NAShareActionBlock actionBlock;

@end

@implementation NAShareView

- (instancetype)initWithActionBlock:(NAShareActionBlock)actionBlock {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.actionBlock = actionBlock;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *grayBGView = [[UIView alloc] initWithFrame:self.bounds];
    grayBGView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    [self addSubview:grayBGView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [grayBGView addGestureRecognizer:tapGes];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kShareMainViewH)];
    mainView.backgroundColor = [UIColor colorFromString:@"dfdfdf"];
    [self addSubview:mainView];
    self.mainView = mainView;
    
    UILabel *tiplabel = [[UILabel alloc]init];
    tiplabel.frame = CGRectMake(15, 15, 200, 15);
    tiplabel.text = @"分享到：";
    tiplabel.textAlignment = NSTextAlignmentLeft;
    tiplabel.font = [UIFont systemFontOfSize:16];
    [self.mainView addSubview:tiplabel];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    cancelBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+290, [UIScreen mainScreen].bounds.size.width, 50);
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:cancelBtn];
    
    CGFloat leftMargin = 62;
    CGFloat topMargin = 42;
    CGFloat xMargin = 52;
    CGFloat yMargin = 42;
    CGFloat width = (kScreenWidth - 2 * leftMargin - 2 * xMargin) / 3;
    NSArray *titleArr = @[@"微信", @"朋友圈", @"QQ", @"QQ空间"];
    NSArray *iconArr = @[@"weixin", @"quan", @"qq", @"qzone"];
    for (int i=0; i<titleArr.count; i++) {
        int col = i%3;
        int row = i/3;
        CGFloat btnX = leftMargin + col * (width + xMargin);
        CGFloat btnY = topMargin + (yMargin + width) * row;
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(btnX, btnY, width, width);
        [btn setBackgroundImage:kGetImage(([NSString stringWithFormat:@"%@",iconArr[i]])) forState:UIControlStateNormal];
        [self.mainView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] init];
        CGFloat labX = leftMargin + col * (width + xMargin);
        CGFloat labY = topMargin + (yMargin + width) * row + width + 7;
        label.frame = CGRectMake(labX-10, labY, width+20, 14);
        label.text = [NSString stringWithFormat:@"%@",titleArr[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [self.mainView addSubview:label];
        
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(onShareItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.frame = CGRectMake(0, kScreenHeight - kShareMainViewH, kScreenWidth, kShareMainViewH);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kShareMainViewH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)onShareItemClicked:(UIButton *)button {
    if (self.actionBlock) self.actionBlock(button.tag - 100);
}

@end
