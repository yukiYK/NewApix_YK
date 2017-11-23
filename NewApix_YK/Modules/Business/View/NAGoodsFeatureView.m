//
//  NAGoodsFeatureView.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/20.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAGoodsFeatureView.h"


@interface NAGoodsFeatureView ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel2;

@property (nonatomic, strong) UIButton *selectedBtn1;
@property (nonatomic, strong) UIButton *selectedBtn2;

@property (nonatomic, strong) NSArray *childArr;

@property (nonatomic, strong) NAGoodsChildModel *childModel;

@end

static CGFloat const kButtonHeight = 28;
static CGFloat const kButtonMargin = 20;

@implementation NAGoodsFeatureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithTitle1:(NSString *)title1 title2:(NSString *)title2 childArr:(NSArray *)childArr {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        self.childArr = childArr;
        self.childModel = [NAGoodsChildModel yy_modelWithJSON:childArr[0]];
        
        [self setupSubviewsWithTitle1:title1 title2:title2 childArr:childArr];
    }
    return self;
}

- (void)setupSubviewsWithTitle1:(NSString *)title1 title2:(NSString *)title2 childArr:(NSArray *)childArr {
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.6;
    [self addSubview:bgView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tapGes];
    
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight * 0.4)];
    mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:mainView];
    self.mainView = mainView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.4 - 44)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 解析数据
    NSMutableArray *featureArr1 = [NSMutableArray array];
    NSMutableArray *featureArr2 = [NSMutableArray array];
    NAGoodsChildModel *childModel1 = [NAGoodsChildModel yy_modelWithJSON:childArr[0]];
    for (NSDictionary *dic in childArr) {
        NAGoodsChildModel *childModel = [NAGoodsChildModel yy_modelWithJSON:dic];
        if (childModel.main_feature.length > 0 && ![featureArr1 containsObject:childModel.main_feature]) {
            [featureArr1 addObject:childModel.main_feature];
        }
        if (childModel.secondary_feature.length > 0 && ![featureArr2 containsObject:childModel.secondary_feature] && [childModel.main_feature isEqualToString:childModel1.main_feature]) {
            [featureArr2 addObject:childModel.secondary_feature];
        }
    }
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(kButtonMargin, kButtonMargin, kScreenWidth - kButtonMargin * 2, 20)];
    titleLabel1.font = [UIFont systemFontOfSize:15];
    titleLabel1.text = title1.length > 0 ? title1 : @"商品规格";
    [scrollView addSubview:titleLabel1];
    
    CGFloat buttonX = kButtonMargin;
    CGFloat buttonY = CGRectGetMaxY(titleLabel1.frame) + kButtonMargin;
    for (int i=0; i<featureArr1.count; i++) {
        UIButton *button = [self buttonWithFrame:CGRectMake(buttonX, buttonY, 0, kButtonHeight) title:featureArr1[i]];
        button.tag = 200 + i;
        [scrollView addSubview:button];
        
        buttonX = button.x + button.width + kCommonMargin * 2;
        buttonY = button.y;
    }
    scrollView.contentSize = CGSizeMake(kScreenWidth, buttonY + kButtonHeight + kButtonMargin);
    
    
    if (title2.length > 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, buttonY + kButtonHeight + 12, kScreenWidth, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [scrollView addSubview:line];
        
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kButtonMargin, line.y + kButtonMargin, kScreenWidth - kButtonMargin * 2, 20)];
        titleLabel2.font = [UIFont systemFontOfSize:15];
        titleLabel2.text = title2;
        [scrollView addSubview:titleLabel2];
        self.titleLabel2 = titleLabel2;
        
        CGFloat buttonX2 = kButtonMargin;
        CGFloat buttonY2 = CGRectGetMaxY(titleLabel2.frame) + kButtonMargin;
        for (int i=0; i<featureArr2.count; i++) {
            UIButton *button = [self buttonWithFrame:CGRectMake(buttonX2, buttonY2, 0, kButtonHeight) title:featureArr2[i]];
            button.tag = 300 + i;
            [scrollView addSubview:button];
            
            buttonX2 = button.x + button.width + kCommonMargin * 2;
            buttonY2 = button.y;
        }
        scrollView.contentSize = CGSizeMake(kScreenWidth, buttonY2 + kButtonHeight + kButtonMargin);
    }
    
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight * 0.4 - 44, kScreenWidth, 44)];
    confirmBtn.backgroundColor = kColorTextRed;
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(onConfirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:confirmBtn];
}

- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:kColorTextRed forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    CGSize size = [title sizeWithAttributes:attributes];
    button.width = size.width + 20;
    
    if (CGRectGetMaxX(button.frame) > kScreenWidth - kButtonMargin) {
        button.x = kCommonMargin;
        button.y += kButtonHeight + 12;
    }
    
    return button;
}

- (void)resetTitle2View:(NSArray *)arr2 {
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag >= 300) [view removeFromSuperview];
    }
    
    CGFloat buttonX2 = kButtonMargin;
    CGFloat buttonY2 = CGRectGetMaxY(self.titleLabel2.frame) + kButtonMargin;
    for (int i=0; i<arr2.count; i++) {
        UIButton *button = [self buttonWithFrame:CGRectMake(buttonX2, buttonY2, 0, kButtonHeight) title:arr2[i]];
        button.tag = 300 + i;
        [self.scrollView addSubview:button];
        
        buttonX2 = button.x + button.width + kCommonMargin * 2;
        buttonY2 = button.y;
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, buttonY2 + kButtonHeight + kButtonMargin);
}

#pragma mark - <Events>
- (void)onBtnClicked:(UIButton *)button {
    if (button.selected) return;
    
    if (button.tag >= 200 && button.tag < 300) {
        if (self.selectedBtn1) {
            self.selectedBtn1.selected = NO;
            self.selectedBtn1.layer.borderColor = [UIColor blackColor].CGColor;
        }
        self.selectedBtn1 = button;
        
        if (self.titleLabel2) {
            NSMutableArray *arr2 = [NSMutableArray array];
            for (NSDictionary *dic in self.childArr) {
                NAGoodsChildModel *childModel = [NAGoodsChildModel yy_modelWithJSON:dic];
                if ([[button titleForState:UIControlStateNormal] isEqualToString:childModel.main_feature]) {
                    [arr2 addObject:childModel.secondary_feature];
                }
            }
            [self resetTitle2View:arr2];
        }
    } else if (button.tag >= 300) {
        if (self.selectedBtn2) {
            self.selectedBtn2.selected = NO;
            self.selectedBtn2.layer.borderColor = [UIColor blackColor].CGColor;
        }
        self.selectedBtn2 = button;
    }
    button.selected = YES;
    button.layer.borderColor = kColorTextRed.CGColor;
}

- (void)onConfirmBtnClicked:(UIButton *)button {
    if (self.block) {
        
        // 如果只选择了第一项
        if (self.selectedBtn1 && !self.selectedBtn2) {
            NSString *resultStr1 = [self.selectedBtn1 titleForState:UIControlStateNormal];
            for (NSDictionary *dic in self.childArr) {
                NAGoodsChildModel *childModel = [NAGoodsChildModel yy_modelWithJSON:dic];
                if ([resultStr1 isEqualToString:childModel.main_feature]) {
                    self.block(childModel);
                    [self dismiss];
                    return;
                }
            }
            // 只选择了第二项
        } else if (self.selectedBtn2 && !self.selectedBtn1) {
            NSString *resultStr2 = [self.selectedBtn2 titleForState:UIControlStateNormal];
            for (NSDictionary *dic in self.childArr) {
                NAGoodsChildModel *childModel = [NAGoodsChildModel yy_modelWithJSON:dic];
                if ([resultStr2 isEqualToString:childModel.secondary_feature]) {
                    self.block(childModel);
                    [self dismiss];
                    return;
                }
            }
            // 两项都选择
        } else if (self.selectedBtn1 && self.selectedBtn2) {
            NSString *resultStr1 = [self.selectedBtn1 titleForState:UIControlStateNormal];
            NSString *resultStr2 = [self.selectedBtn2 titleForState:UIControlStateNormal];
            for (NSDictionary *dic in self.childArr) {
                NAGoodsChildModel *childModel = [NAGoodsChildModel yy_modelWithJSON:dic];
                if ([resultStr1 isEqualToString:childModel.main_feature] && [resultStr2 isEqualToString:childModel.secondary_feature]) {
                    self.block(childModel);
                    [self dismiss];
                    return;
                }
            }
        }
        
        NAGoodsChildModel *childModel = [NAGoodsChildModel yy_modelWithJSON:self.childArr[0]];
        self.block(childModel);
        [self dismiss];
    }
}


- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.frame = CGRectMake(0, kScreenHeight * 0.6, kScreenWidth, kScreenHeight * 0.4);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight * 0.4);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
