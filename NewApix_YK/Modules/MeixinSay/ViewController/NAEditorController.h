//
//  NAEditorController.h
//  NewApix_YK
//
//  Created by APiX on 2017/11/7.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import <WordPressEditor/WPEditorViewController.h>

typedef NS_ENUM(NSInteger, NAEditorType) {
    NAEditorTypePost = 0, // 发帖
    NAEditorTypeComment,  // 评论
    NAEditorTypeReply     // 回复
};


@interface NAEditorController : WPEditorViewController <WPEditorViewControllerDelegate>

@property (nonatomic, assign) NAEditorType editorType;

/** 回复楼层 */
@property (nonatomic, copy) NSString *floorStr;
//@property (nonatomic, copy) NSString *userLoginStr;
/** 回复别人的昵称 */
@property (nonatomic, copy) NSString *nickName;
/** 评论id */
@property (nonatomic, copy) NSString *commentIDStr;

@end
