//
//  NAPhonePayController.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/13.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAPhonePayController.h"
#import "NAGoodsPriceModel.h"
#import "NAConfirmOrderModel.h"

@interface NAPhonePayController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *phoneAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipOnlyLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *vipBuyBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *buyPriceLabel;

@property (nonatomic, strong) UIButton *selectPriceBtn;

/** 会员等级 */
@property (nonatomic, strong) NSMutableArray *vipGrade;
/** 价格数组 */
@property (nonatomic, strong) NSArray *priceArr;
@property (nonatomic, strong) NSDictionary *parentsDic;

@end

@implementation NAPhonePayController
- (NSMutableArray *)vipGrade {
    if (!_vipGrade)
        _vipGrade = [NSMutableArray array];
    return _vipGrade;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customTitleLabel.text = @"特价话费";
    
    if ([NAUserTool getPhoneNumber]) {
        self.phoneTextField.text = [NAUserTool getPhoneNumber];
        [self requestForPhoneAddress];
    }
    
    [self requestForPhonePayPrice];
}

- (void)setupPriceButtons:(NSArray *)priceArr {
    for (int i=0; i<priceArr.count; i++) {
        NSDictionary *dic = priceArr[i];
        NAGoodsPriceModel *priceModel = [NAGoodsPriceModel yy_modelWithJSON:dic];
        
        NSInteger x = i % 3;
        NSInteger y = i / 3;
        CGFloat buttonWidth = (kScreenWidth - kCommonMargin * 4) / 3.0;
        CGFloat buttonHeight = buttonWidth * 0.6;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kCommonMargin + (buttonWidth + kCommonMargin) * x, kCommonMargin + (buttonHeight + kCommonMargin) * y, buttonWidth, buttonHeight)];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.masksToBounds = YES;
        button.layer.borderColor = kColorBlue.CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 6;
        button.tag = 100 + i;
        [button addTarget:self action:@selector(onPriceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonHeight/2 - 16, buttonWidth, 20)];
        priceLabel.font = [UIFont systemFontOfSize:18];
        priceLabel.textColor = kColorBlue;
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.text = [NSString stringWithFormat:@"%@元", priceModel.default_price];
        priceLabel.tag = 11;
        [button addSubview:priceLabel];
        
        UILabel *vipPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonHeight/2 + 4, buttonWidth, 12)];
        vipPriceLabel.font = [UIFont systemFontOfSize:10];
        vipPriceLabel.textColor = [UIColor colorFromString:@"96bbff"];
        vipPriceLabel.textAlignment = NSTextAlignmentCenter;
        if (self.vipGrade.count > 0)
            vipPriceLabel.text = [NSString stringWithFormat:@"会员价%@元", priceModel.second_class_cost];
        else vipPriceLabel.text = [NSString stringWithFormat:@"%@元", priceModel.second_class_cost];
        vipPriceLabel.tag = 12;
        [button addSubview:vipPriceLabel];
        
        if (i == 0) [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buySoon {
    if (![self isPhoneNumber:self.phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    // TODO 跳转订单页
    NAGoodsPriceModel *priceModel = [NAGoodsPriceModel yy_modelWithJSON:self.priceArr[self.selectPriceBtn.tag - 100]];
    NAConfirmOrderModel *model = [[NAConfirmOrderModel alloc] init];
    model.ptypeId = priceModel.id;
    model.ptype = priceModel.main_feature;
    model.title = self.parentsDic[@"attraction"];
    model.img = self.parentsDic[@"img"];
    model.money = priceModel.second_class_cost;
    model.orderType = @"1";
    model.phone_num = self.phoneTextField.text;
    
    [NAViewControllerCenter transformViewController:self
                                   toViewController:[NAViewControllerCenter confirmOrderControllerWithModel:model]
                                      tranformStyle:NATransformStylePush needLogin:YES];
}

- (BOOL)isPhoneNumber:(NSString *)phoneNumber {
    NSString *phone = @"^1[3-9]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    
    return [predicate evaluateWithObject:phoneNumber];
}

#pragma mark - <Net Request>
- (void)requestForPhonePayPrice {
    NAAPIModel *model = [NAURLCenter goodsDetailConfigWithProductID:@"1"];
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        weakSelf.priceArr = returnValue[@"child_products"] ? returnValue[@"child_products"] : [NSArray array];
        weakSelf.parentsDic = returnValue[@"parent_product"];
        [weakSelf.vipGrade addObjectsFromArray:returnValue[@"member_class"]];
        [weakSelf setupPriceButtons:weakSelf.priceArr];
        
    } errorCodeBlock:nil failureBlock:nil];
}

- (void)requestForPhoneAddress {
    NAAPIModel *model = [NAURLCenter phoneAddressConfigWithPhoneNumber:self.phoneTextField.text];
    
    NAHTTPSessionManager *manager = [NAHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    WeakSelf
    [self.netManager netRequestWithApiModel:model progress:nil returnValueBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@", returnValue);
        
        NSDictionary *dataDic = returnValue[@"data"] ? returnValue[@"data"] : [NSDictionary dictionary];
        if (dataDic.count > 0) {
            NSString *operator = dataDic[@"operator"];
            NSString *str = [operator substringFromIndex:2];
            weakSelf.phoneAddressLabel.hidden = NO;
            weakSelf.phoneAddressLabel.text = [NSString stringWithFormat:@"%@%@", dataDic[@"province"], str];
        } else weakSelf.phoneAddressLabel.hidden = YES;
    } errorCodeBlock:nil failureBlock:nil];
}

#pragma mark - <Events>
- (IBAction)textFieldEditingChanged:(id)sender {
    UITextField *textField = (UITextField *)sender;
    if (![self isPhoneNumber:textField.text]) {
        self.phoneAddressLabel.hidden = YES;
        return;
    }
    
    [self requestForPhoneAddress];
}

- (IBAction)onBuyBtnClicked:(id)sender {
    if (!self.selectPriceBtn) return;
    
    if (self.vipGrade.count > 0 && [self.vipGrade[0] integerValue] == 2) {
        [self buySoon];
    } else
        [NAViewControllerCenter transformViewController:self toViewController:[NAViewControllerCenter meixinVIPControllerWithIsFromGiftCenter:NO] tranformStyle:NATransformStylePush needLogin:YES];
}

- (void)onPriceBtnClicked:(UIButton *)button {
    if (button.selected) return;
    
    if (self.selectPriceBtn) {
        self.selectPriceBtn.selected = NO;
        self.selectPriceBtn.backgroundColor = [UIColor whiteColor];
        for (UIView *view in self.selectPriceBtn.subviews) {
            if (view.tag == 11 || view.tag == 12) {
                UILabel *priceLabel = (UILabel *)view;
                priceLabel.textColor = kColorBlue;
            }
        }
    }
    
    NSInteger index = button.tag - 100;
    button.selected = YES;
    button.backgroundColor = kColorBlue;
    for (UIView *view in button.subviews) {
        if (view.tag == 11 || view.tag == 12) {
            UILabel *priceLabel = (UILabel *)view;
            priceLabel.textColor = [UIColor whiteColor];
        }
    }
    self.selectPriceBtn = button;
    
    NAGoodsPriceModel *priceModel = [NAGoodsPriceModel yy_modelWithJSON:self.priceArr[index]];
    self.buyPriceLabel.text = [NSString stringWithFormat:@"%@元", priceModel.second_class_cost];
}

@end
