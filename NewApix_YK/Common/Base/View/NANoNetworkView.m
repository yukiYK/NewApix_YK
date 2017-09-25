//
//  NANoNetworkView.m
//  NewApix_YK
//
//  Created by APiX on 2017/7/31.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NANoNetworkView.h"

static NSString *const noNetworkText = @"网络连接已断开";
static NSString *const noDataText = @"暂无数据";
static NSString *const tipsText = @"点击空白刷新";

@implementation NANoNetworkView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

+ (NANoNetworkView *)viewForNoNet {
    
    NANoNetworkView *view = [[NANoNetworkView alloc] initWithFrame:CGRectMake(0, kTopViewH, kScreenWidth, kScreenHeight-kTopViewH)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,view.bounds.size.height/2 - 30 , kScreenWidth, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorFromString:@"848585"];
    label.font = [UIFont systemFontOfSize:14.0];
    label.numberOfLines = 2;
    label.text = noNetworkText;
    [view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((kScreenWidth - 100) / 2.0, view.bounds.size.height/2, 100, 32);
    [button setTitle:tipsText forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitleColor:[UIColor colorFromString:@"848585"] forState:UIControlStateNormal];
    [button setUserInteractionEnabled:NO];
    [view addSubview:button];
    
    return view;
}

+ (NANoNetworkView *)viewForNoData {
    
    NANoNetworkView *view = [[NANoNetworkView alloc] initWithFrame:CGRectMake(0, kTopViewH, kScreenWidth, kScreenHeight-kTopViewH)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,view.bounds.size.height/2 - 30 , kScreenWidth, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorFromString:@"848585"];
    label.font = [UIFont systemFontOfSize:14.0];
    label.numberOfLines = 2;
    label.text = noDataText;
    [view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((kScreenWidth - 100) / 2.0, view.bounds.size.height/2, 100, 32);
    [button setTitle:tipsText forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitleColor:[UIColor colorFromString:@"848585"] forState:UIControlStateNormal];
    [button setUserInteractionEnabled:NO];
    [view addSubview:button];
    
    return view;
}

@end
