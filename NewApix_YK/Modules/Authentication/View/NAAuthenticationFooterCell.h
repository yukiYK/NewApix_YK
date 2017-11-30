//
//  NAAuthenticationFooterCell.h
//  NewApix_YK
//
//  Created by hg-macair on 2017/11/30.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseBankBlock) (void);
typedef void(^AllowBlock) (BOOL isAllow);
typedef void(^ProtocolBlock) (void);

@interface NAAuthenticationFooterCell : UICollectionViewCell

@property (nonatomic, copy) ChooseBankBlock chooseBankBlock;
@property (nonatomic, copy) AllowBlock allowBlock;
@property (nonatomic, copy) ProtocolBlock protocolBlock;

- (void)setBankIcon:(NSString *)bankIcon bankName:(NSString *)bankName;

- (void)isBankChoosed:(BOOL)isChoosed;

@end
