//
//  NAArticleDetailController.h
//  NewApix_YK
//
//  Created by APiX on 2017/11/2.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NABaseViewController.h"

typedef NS_ENUM(NSInteger, NAArticleType) {
    NAArticleTypeEssence,
    NAArticleTypeCommunity
};

@interface NAArticleDetailController : NABaseViewController

@property (nonatomic, assign) NAArticleType articleType;
@property (nonatomic, copy) NSString *articleUrl;
@property (nonatomic, copy) NSString *articleTitle;

@end
