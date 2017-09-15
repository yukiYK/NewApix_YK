//
//  NAPickerView.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/15.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAPickerView.h"

static CGFloat const kTopViewHeight = 30;
static CGFloat const kButtonWidth = 60;
static CGFloat const kAnimationDuration = 0.3;

@interface NAPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *mainView;
//@property (nonatomic, strong) UIPickerView *pickerView;
//@property (nonatomic, strong) UIView *topView;
//@property (nonatomic, strong) UIButton *confirmButton;
//@property (nonatomic, strong) UIButton *cancelButton;

// 数据数组  
@property (nonatomic, strong) NSArray *dataArr;

/** 是否只有一列 */
@property (nonatomic, assign) BOOL isColumnOne;

@end

@implementation NAPickerView
#pragma mark - <Lazy Load>
- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kTopViewHeight + 200)];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
        topView.backgroundColor = [UIColor whiteColor];
        [_mainView addSubview:topView];
        
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - kButtonWidth - 8, 0, kButtonWidth, kTopViewHeight)];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [confirmButton addTarget:self action:@selector(onConfirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:confirmButton];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 0, kButtonWidth, kTopViewHeight)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [cancelButton addTarget:self action:@selector(onCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:cancelButton];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), kScreenWidth, 200)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [_mainView addSubview:pickerView];
    }
    return _mainView;
}


#pragma mark - <init>
- (instancetype)initWithDataArray:(NSArray *)dataArr {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.dataArr = dataArr;
        self.isColumnOne = YES;
        
        for (id item in dataArr) {
            if ([item isKindOfClass:[NSArray class]]) {
                self.isColumnOne = NO;
            }
        }
        
        [self addSubview:self.mainView];
    }
    return self;
}

- (void)show {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
    }];
}

#pragma mark - <Private Method>

#pragma mark - <Events>
- (void)onConfirmButtonClicked:(UIButton *)button {
}

- (void)onCancelButtonClicked:(UIButton *)button {
}

#pragma mark - <UIPickerViewDelegate, UIPickerViewDataSource>
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (!_isColumnOne) {
        
        id item = _dataArr[component];
        if ([item isKindOfClass:[NSArray class]]) {
            NSArray *array = item;
            return array.count;
        }
        return 0;
    }
    return _dataArr.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _isColumnOne?1:_dataArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"";
}

@end
