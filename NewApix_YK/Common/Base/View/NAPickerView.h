//
//  NAPickerView.h
//  NewApix_YK
//
//  Created by APiX on 2017/9/15.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NAPickerViewDelegate <NSObject>

- (void)pickerViewCompleteWithResult:(NSArray *)resultArr;

- (void)pickerViewCancel;

@end



@interface NAPickerView : UIView

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *pickViewBackgroundColor;
@property (nonatomic, strong) UIColor *topViewBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonColor;
@property (nonatomic, strong) UIColor *sureButtonColor;

@property (nonatomic, weak) id<NAPickerViewDelegate> delegate;


/**
 初始化方法

 @param dataArr 数据数组  如果是[a, b, c,...]则pickerView只有一列，如果[[a,b,c], [a,b,c],...]，则pickerView为多列
        请一定按这两种方式传入数据！！！
 @return NAPickerView对象
 */
- (instancetype)initWithDataArray:(NSArray *)dataArr;

/** 显示 */
- (void)show;

@end
