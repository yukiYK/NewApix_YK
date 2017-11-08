//
//  NAEditorController.m
//  NewApix_YK
//
//  Created by APiX on 2017/11/7.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NAEditorController.h"
//#import <WordPressShared/WPStyleGuide.h>
//#import <WordPressShared/WPFontManager.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <WordPressEditor/WPEditorView.h>
#import "MBProgressHUD.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
@import Photos;
@import AVFoundation;
@import MobileCoreServices;


@interface NAEditorController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *mediaAdded;
@property (nonatomic, copy) NSString *selectedMediaID;
@property (nonatomic, strong) NSData *picData;
@property (nonatomic, copy) NSString *imgUrlStr;
@property (nonatomic, copy) NSString *phoneName;
@property (nonatomic, copy) NSString *nickAppendStr;

@end

@implementation NAEditorController
#pragma mark - <Lazy Load>
- (NSMutableDictionary *)mediaAdded {
    if (!_mediaAdded) {
        _mediaAdded = [NSMutableDictionary dictionary];
    }
    return _mediaAdded;
}

#pragma mark - <Life Cycle>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.phoneName = [NAUserTool getPhoneNumber];
    // 获取WebView用来加载html
    UIWebView *webView = (UIWebView *)self.editorView.subviews[3];
    NSBundle * bundle = [NSBundle bundleForClass:[WPEditorView class]];
    NSString *fileName;
    switch (self.editorType) {
        case NAEditorTypePost:
            fileName = @"editor";
            break;
        case NAEditorTypeReply:
        case NAEditorTypeComment:
            fileName = @"review";
            break;
        default:
            break;
    }
    NSURL *editorURL = [bundle URLForResource:fileName withExtension:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:editorURL]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)setupNavigation {
    switch (self.editorType) {
        case NAEditorTypePost:
            self.title = @"发帖";
            break;
        case NAEditorTypeComment:
            self.title = @"评论";
            break;
        case NAEditorTypeReply:
            self.title = @"回复评论";
            break;
        default:
            break;
    }
    //添加发表评论的按钮
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 50, 50);
    right.titleLabel.font = [UIFont systemFontOfSize:15];
    [right addTarget:self action:@selector(onSendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [right setTitle:@"发表" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBut;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 20, 30)];
    [left addTarget:self action:@selector(onBackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [left setImage:kGetImage(kImageBackBlack) forState:UIControlStateNormal];
    [left setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //修改方法
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [view addSubview:left];
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftBut;
}

- (void)customizeAppearance {
    [super customizeAppearance];
//    [WPFontManager merriweatherBoldFontOfSize:16.0];
//    [WPFontManager merriweatherBoldItalicFontOfSize:16.0];
//    [WPFontManager merriweatherItalicFontOfSize:16.0];
//    [WPFontManager merriweatherLightFontOfSize:16.0];
//    [WPFontManager merriweatherRegularFontOfSize:16.0];

    //self.placeholderColor = [WPStyleGuide grey];
    self.placeholderColor = [UIColor colorFromString:@"333333"];
    self.editorView.sourceViewTitleField.font = [UIFont systemFontOfSize:24];//[WPFontManager merriweatherBoldFontOfSize:24.0];
    //self.editorView.sourceContentDividerView.backgroundColor = [WPStyleGuide greyLighten30];
    self.editorView.sourceContentDividerView.backgroundColor = [UIColor colorFromString:@"333333"];
//    [self colorWithR:168 G:190 B:206 alpha:1.0];
    UIColor *color = [UIColor colorWithRed:168.0/255.0 green:190.0/255.0 blue:206.0/255.0 alpha:1.0];
    [self.toolbarView setBorderColor:color];
    [self.toolbarView setItemTintColor:color];
    [self.toolbarView setSelectedItemTintColor:[UIColor colorWithRed:0.0/255.0 green:135.0/255.0 blue:190.0/255.0 alpha:1.0]];
    [self.toolbarView setDisabledItemTintColor:[UIColor colorWithRed:0.78 green:0.84 blue:0.88 alpha:0.5]];
    // Explicit design decision to use non-standard colors. See:
    // https://github.com/wordpress-mobile/WordPress-Editor-iOS/issues/657#issuecomment-113651034
    [self.toolbarView setBackgroundColor: [UIColor colorWithRed:0xF9/255.0 green:0xFB/255.0 blue:0xFC/255.0 alpha:1]];
}

#pragma mark - Navigation Bar
//1008 更改按钮 1011替换成返回
- (void)editTouchedUpInside {
    if (self.isEditing) {
        [self stopEditing];
    } else {
        [self startEditing];
    }
}

#pragma mark - <Net Request>
- (void)requestForReplay {
    
}

#pragma mark - <Events>
- (void)onBackBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSendBtnClicked {
    if ([self.bodyText rangeOfString:@"alt="""].location != NSNotFound) {
        NSLog(@"bodyText = %@",self.bodyText);
        NSRange startRange = [self.bodyText rangeOfString:@"alt="""];
        NSRange endRange = [self.bodyText rangeOfString:@"class"];
        NSRange range = NSMakeRange(0 ,startRange.location);
        NSRange range2 = NSMakeRange(endRange.location, self.bodyText.length-endRange.location);
        NSString *result1 = [self.bodyText substringWithRange:range];
        NSString *resullt2 = [self.bodyText substringWithRange:range2];
        self.bodyText = [NSString stringWithFormat:@"%@%@",result1,resullt2];
    }
    
    if (self.editorType == NAEditorTypeReply || self.editorType == NAEditorTypeComment) {
        if (!self.bodyText.length) {
            [self textExampleWithTitle:@"内容太少了"];
            return;
        } else if (self.bodyText.length > 5000) {
            [self textExampleWithTitle:@"抱歉，发帖字数超过上限500字，请精简或分段发布"];
            return;
        }
        if (self.editorType == NAEditorTypeReply) {
            //1123 拼接
            NSString *bodyText = [NSString stringWithFormat:@"%@%@",self.nickAppendStr,self.bodyText];
            NSDictionary *dict = @{
                                   @"name":self.phoneName,
                                   @"reply[body]":bodyText,
                                   @"id":self.commentIDStr
                                   };
            [self sendUsersCommentWithDict:dict andUrlStr:@"http://community.meixinlife.com/api/bbs_create"];
        } else {
            NSDictionary *dict = @{
                                   @"name":self.phoneName,
                                   @"reply[body]":self.bodyText,
                                   @"id":self.commentIDStr
                                   };
            [self sendUsersCommentWithDict:dict andUrlStr:@"http://community.meixinlife.com/api/bbs_create"];
        }
        
    } else {
        if (!self.titleText.length) {
            [self textExampleWithTitle:@"写个响亮的标题吧"];
            return;
        } else if (self.titleText.length > 30) {
            [self textExampleWithTitle:@"抱歉，标题字数小于30字"];
            return;
        }
        if (!self.bodyText.length) {
            [self textExampleWithTitle:@"内容太少了"];
            return;
        } else if (self.bodyText.length > 5000) {
            [self textExampleWithTitle:@"抱歉，发帖字数超过上限5000字，请精简或分段发布"];
            return;
        }
        
        NSDictionary *dictR = @{
                                @"name":self.phoneName,
                                @"topic[body]":self.bodyText,
                                @"topic[title]":self.titleText,
                                @"topic[node_id]":@"28"
                                };
        [self sendUsersCommentWithDict:dictR andUrlStr:@"http://community.meixinlife.com/api/bbs_create_topic"];
    }
}

#pragma mark - WPEditorViewControllerDelegate

- (void)editorDidBeginEditing:(WPEditorViewController *)editorController {
    //   DDLogInfo(@"Editor did begin editing.");
}

- (void)editorDidEndEditing:(WPEditorViewController *)editorController {
    //   DDLogInfo(@"Editor did end editing.");
}

- (void)editorDidFinishLoadingDOM:(WPEditorViewController *)editorController {
    
    if (self.editorType == NAEditorTypeReply) {
        //        [self setTitleText:@"发表评论"];
        [self setBodyPlaceholderText:@"我也来说两句"];
        if (self.nickName) {
            NSString *str = [NSString stringWithFormat:@"#%@楼<a href=\"#\">@%@: </a>",self.floorStr,self.nickName];
            //1123            [self setBodyText:str];
            self.nickAppendStr = str;
        }
    } else {
        //这是用预留接口写的
        [self setTitlePlaceholderText:@"标题，诱人的会有更多人看到呢~"];
        [self setBodyPlaceholderText:@"内容，好内容上美信头条会有话费充值奖励哦！"];
    }
}

- (void)editorDidPressMedia:(WPEditorViewController *)editorController {
    //  DDLogInfo(@"Pressed Media!");
    [self showPhotoPicker];
}

- (void)editorTitleDidChange:(WPEditorViewController *)editorController {
    //  DDLogInfo(@"Editor title did change: %@", self.titleText);
}

- (void)editorTextDidChange:(WPEditorViewController *)editorController {
    // DDLogInfo(@"Editor body text changed: %@", self.bodyText);
}

- (void)editorViewController:(WPEditorViewController *)editorViewController fieldCreated:(WPEditorField*)field {
    // DDLogInfo(@"Editor field created: %@", field.nodeId);
}
//这个才是展现图片使用的
- (void)editorViewController:(WPEditorViewController*)editorViewController
                 imageTapped:(NSString *)imageId
                         url:(NSURL *)url
                   imageMeta:(WPImageMeta *)imageMeta {
    if (imageId.length == 0) {
        //        [self showImageDetailsForImageMeta:imageMeta];
    } else {
        [self showPromptForImageWithID:imageId];
    }
}


//图片完全上传之后可以走这个方法
- (void)editorViewController:(WPEditorViewController *)editorViewController imageReplaced:(NSString *)imageId {
    [self.mediaAdded removeObjectForKey:imageId];
}

#pragma mark - Media actions
- (void)showPromptForImageWithID:(NSString *)imageId {
    if (imageId.length == 0){
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    UITraitCollection *traits = self.navigationController.traitCollection;
    NSProgress *progress = self.mediaAdded[imageId];
    UIAlertController *alertController;
    if (traits.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleAlert];
    } else {
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action){}];
    [alertController addAction:cancelAction];
    
    if (!progress.cancelled){
        UIAlertAction *stopAction = [UIAlertAction actionWithTitle:@"Stop Upload"
                                                             style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction *action){
                                                               [weakSelf.editorView removeImage:weakSelf.selectedMediaID];
                                                           }];
        [alertController addAction:stopAction];
    } else {
        UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Image"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction *action){
                                                                 [weakSelf.editorView removeImage:weakSelf.selectedMediaID];
                                                             }];
        
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry Upload"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action){
                                                                NSProgress * progress = [[NSProgress alloc] initWithParent:nil userInfo:@{@"imageID":self.selectedMediaID}];
                                                                progress.totalUnitCount = 100;
                                                                [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                                                 target:self
                                                                                               selector:@selector(timerFireMethod:)
                                                                                               userInfo:progress
                                                                                                repeats:YES];
                                                                weakSelf.mediaAdded[weakSelf.selectedMediaID] = progress;
                                                                [weakSelf.editorView unmarkImageFailedUpload:weakSelf.selectedMediaID];
                                                            }];
        [alertController addAction:removeAction];
        [alertController addAction:retryAction];
    }
    
    self.selectedMediaID = imageId;
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

//      1  弹出相册
- (void)showPhotoPicker {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    
}
#pragma mark - UIImagePickerControllerDelegate methods
//   2 选中照片后进入
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //获取图片1008
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        [NSThread sleepForTimeInterval:0.5];
        //先把图片转成NSData
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *data;
        
        if (UIImagePNGRepresentation(image) != nil) {
            //        NSString *daxiao = NSStringFromCGSize(image.size);
            //        NSLog(@"daxiao = %@",daxiao);
            data = UIImageJPEGRepresentation(image,0.3);
        } else if (UIImageJPEGRepresentation(image,0.3) != nil) {
            data = UIImageJPEGRepresentation(image,0.3);
        } else {
            NSLog(@"11111111");
        }
        self.picData = data;
        [NSThread sleepForTimeInterval:0.5];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%f", a];
        NSString *fileName = [NSString stringWithFormat:@"%@icon.png",timeString];
        NSDictionary *dict = @{
                               @"name":self.phoneName
                               };
        
        [manager POST:@"http://community.meixinlife.com/api/photos" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"wqwqwqw = %@",responseObject);
            if ([responseObject[@"ok"] intValue] == 1) {
                self.imgUrlStr = responseObject[@"url"];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    NSURL *assetURL = info[UIImagePickerControllerReferenceURL];
                    [self addAssetToContent:assetURL];
                    return;
                }];
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }
    
}

//    5 此处做了修改 将file切换到http
- (void)addImageDataToContent:(NSData *)imageData {
    NSString *imageID = [[NSUUID UUID] UUIDString];
    NSString *path = self.imgUrlStr;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //       [self.editorView insertLocalImage:[[NSURL fileURLWithPath:path] absoluteString] uniqueId: imageID];
        [self.editorView insertLocalImage:path uniqueId:imageID];
    });
    
    NSProgress *progress = [[NSProgress alloc] initWithParent:nil userInfo:@{ @"imageID": imageID, @"url": path }];
    progress.cancellable = YES;
    progress.totalUnitCount = 100;
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                       target:self
                                                     selector:@selector(timerFireMethod:)
                                                     userInfo:progress
                                                      repeats:YES];
    [progress setCancellationHandler:^{
        [timer invalidate];
    }];
    
    self.mediaAdded[imageID] = progress;
}
//     4
- (void)addImageAssetToContent:(PHAsset *)asset {
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:options
                                                resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                    [self addImageDataToContent:imageData];
                                                }];
}
//       3
- (void)addAssetToContent:(NSURL *)assetURL {
    PHFetchResult *assets = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
    if (assets.count < 1) {
        return;
    }
    PHAsset *asset = [assets firstObject];
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        //        [self addVideoAssetToContent:asset];
    } if (asset.mediaType == PHAssetMediaTypeImage) {
        [self addImageAssetToContent:asset];
    }
}
//展示图片以及进度条啊！！！！
//     6
- (void)timerFireMethod:(NSTimer *)timer {
    NSProgress *progress = (NSProgress *)timer.userInfo;
    progress.completedUnitCount++;
    NSString *imageID = progress.userInfo[@"imageID"];
    if (imageID) {
        [self.editorView setProgress:progress.fractionCompleted onImage:imageID];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        if (progress.fractionCompleted >= 1) {
            
            [self.editorView replaceLocalImageWithRemoteImage:self.imgUrlStr uniqueId:imageID mediaId:[@(arc4random()) stringValue]];
            
            [timer invalidate];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        return;
    }
}

- (void)sendUsersCommentWithDict:(NSDictionary *)dict andUrlStr:(NSString *)urlStr {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"mes"] isEqualToString:@"ok"]){
            [self textExampleWithTitle:@"发表成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self popAlartWithtitle:@"发表失败请重新发送"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)popAlartWithtitle:(NSString *)title {
    [self.view endEditing:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *isCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.view endEditing:YES];
    }];
    [alertController addAction:isCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)textExampleWithTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(title, @"message title");
    hud.frame = CGRectMake(50, 200, [UIScreen mainScreen].bounds.size.width-100, 200);
    [hud hideAnimated:YES afterDelay:2.f];
}

@end
