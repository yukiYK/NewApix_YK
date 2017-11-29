//
//  NAAuthenticationController.m
//  NewApix_YK
//
//  Created by hg-macair on 2017/11/27.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAAuthenticationController.h"

static NSString * const kAuthenticationCellName = @"NAAuthenticationCell";
static NSString * const kAuthenticationCellID = @"authenticationCell";
static NSString * const kAuthenticationTitleCellName = @"NAAuthenticationTitleCell";
static NSString * const kAuthenticationTitleCellID = @"authenticationTitleCell";

@interface NAAuthenticationController ()

@end

@implementation NAAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
}

- (void)setupNavigation {
    self.customTitleLabel.text = @"拼信用";
}

- (void)setupCollectionView {
    
}



@end
