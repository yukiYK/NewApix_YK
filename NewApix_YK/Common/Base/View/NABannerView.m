//
//  NABannerView.m
//  NewApix_YK
//
//  Created by APiX on 2017/8/7.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "NABannerView.h"

@interface NABannerView () <UIScrollViewDelegate>

// 界面
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

// 数据源
@property (nonatomic, strong) NSArray *cardArray;
@property (nonatomic, copy) BannerClickedBlock clickBlock;

@property (nonatomic, strong) NSTimer *timer;
/** 是否已经在自动滚动 */
@property (nonatomic, assign) BOOL isAnimate;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *imageViewArray;

@end

@implementation NABannerView
#pragma mark - <Lazy Load>
- (NSMutableArray *)imageViewArray {
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

#pragma mark - <Public Method>
- (instancetype)initWithFrame:(CGRect)frame
                    cardArray:(NSArray *)cardArray
                   clickBlock:(BannerClickedBlock)clickBlock {
    if (self = [super initWithFrame:frame]) {
        self.cardArray = cardArray.copy;
        self.clickBlock = clickBlock;
        self.currentPage = 1;
        [self setupSubviews];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(bannerScroll) userInfo:nil repeats:YES];
        self.timer = timer;
    }
    return self;
}

- (void)startAnimation {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(bannerScroll) userInfo:nil repeats:YES];
    self.timer = timer;
}

- (void)stopAnimation {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - <Private Method>
- (void)setupSubviews {
    
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    // imageViews
    CGFloat cardWidth = self.bounds.size.width;
    if (self.cardArray.count <= 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, self.bounds.size.height)];
        imageView.image = [[UIImage imageNamed:@"defaultImage"] cutImageAdaptImageViewSize:imageView.bounds.size];
        [self.scrollView addSubview:imageView];
        self.scrollView.contentSize = self.bounds.size;
    }
    else {
        for (int i=0;i<self.cardArray.count + 2;i++) {
            
            NAMainCardModel *cardModel = nil;
            if (i == 0) {
                cardModel = self.cardArray.lastObject;
            }
            else if (i == self.cardArray.count + 1) {
                cardModel = self.cardArray.firstObject;
            }
            else {
                cardModel = self.cardArray[i-1];
            }
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cardWidth * i, 0, cardWidth, self.bounds.size.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:cardModel.img] placeholderImage:[[UIImage imageNamed:@"defaultImage"] cutImageAdaptImageViewSize:imageView.bounds.size]];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 100 + i;
            [self.scrollView addSubview:imageView];
            [self.imageViewArray addObject:imageView];
            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageClicked:)];
            [imageView addGestureRecognizer:tapGes];
        }
        self.scrollView.contentSize = CGSizeMake(cardWidth * (self.cardArray.count + 2), self.bounds.size.height);
    }
    
    // pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.currentPageIndicatorTintColor = [UIColor brownColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}



#pragma mark - <事件>
- (void)bannerScroll {
    
}

- (void)onImageClicked:(UIImageView *)imageView {
    NSInteger index = imageView.tag - 100;
    NAMainCardModel *cardModel = self.cardArray[index];
    if (self.clickBlock) {
        self.clickBlock(cardModel);
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
