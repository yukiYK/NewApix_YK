//
//  UINavigationController+NAStatusBar.m
//  NewApix_YK
//
//  Created by APiX on 2017/9/26.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "UINavigationController+NAStatusBar.h"

@implementation UINavigationController (NAStatusBar)

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topViewController] preferredStatusBarStyle];
}

@end
