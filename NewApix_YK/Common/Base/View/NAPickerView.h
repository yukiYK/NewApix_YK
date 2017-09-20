//
//  NAPickerView.h
//  NewApix_YK
//
//  Created by APiX on 2017/9/15.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NAPickerViewStyle) {
    NAPickerViewStyleSingleColumn,   // 单列
    NAPickerViewStyleMultipleColumn, // 多列，不联动
    NAPickerViewStyleLinkageColumn   // 多列，联动
};

@protocol NAPickerViewDelegate <NSObject>

- (void)pickerViewCompleteWithResult:(NSArray *)resultArr;

- (void)pickerViewCancel;

@end



@interface NAPickerView : UIView

//@property (nonatomic, strong) UIFont *titleFont;
//@property (nonatomic, strong) UIColor *pickViewBackgroundColor;
//@property (nonatomic, strong) UIColor *topViewBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonColor;
@property (nonatomic, strong) UIColor *sureButtonColor;

@property (nonatomic, weak) id<NAPickerViewDelegate> delegate;



/**
 初始化方法

 @param dataArr 数据数组  请根据不同的style传不同格式的array
                [a,b,c]
                [[a,b,c],[d,e,f],[g,h,i]]
                [{}, {}, {}] 比较复杂，就不细写了。。。配合keyArr用的，你应该懂的
 @param style  pickerView的类型
 @return NAPickerView对象
 */
- (instancetype)initWithDataArray:(NSArray *)dataArr pickerViewStyle:(NAPickerViewStyle)style;


/**
 设置联动的两个key数组，如果是联动的style请一定要设置，否则无法获取数据。
 其他style的无需设置

 @param resultKeyArr 每一层取值的key  例如 [provinceName, cityName, areaName]
 @param nextKeyArr 每一层获取下一层数组的key 例如[cityList, areaList]
 注意：前者数组的count必须为后者count+1才对，否则数据无法解析
 */
- (void)setResultKeyArr:(NSArray *)resultKeyArr nextKeyArr:(NSArray *)nextKeyArr;

/** 显示 */
- (void)show;

@end
