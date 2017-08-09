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
        imageView.image = [kGetImage(kImageDefault) cutImageAdaptImageViewSize:imageView.bounds.size];
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
            [imageView sd_setImageWithURL:[NSURL URLWithString:cardModel.img] placeholderImage:[kGetImage(kImageDefault) cutImageAdaptImageViewSize:imageView.bounds.size]];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 100 + i - 1;
            [self.scrollView addSubview:imageView];
            [self.imageViewArray addObject:imageView];
            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageClicked:)];
            [imageView addGestureRecognizer:tapGes];
        }
        self.scrollView.contentSize = CGSizeMake(cardWidth * (self.cardArray.count + 2), self.bounds.size.height);
    }
    
    // pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:self.bounds];
    pageControl.currentPageIndicatorTintColor = [UIColor brownColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.numberOfPages = self.cardArray.count;
    [pageControl addTarget:self action:@selector(onPageControlClicked:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)fixContentOffset {
    
    CGFloat scrollWidth = self.bounds.size.width;
    if (self.scrollView.contentOffset.x > scrollWidth * (self.cardArray.count + 1) * 1.1) {
        [self.scrollView setContentOffset:CGPointMake(scrollWidth, 0)];
    }
    else if (self.scrollView.contentOffset.x < scrollWidth * 0.9) {
        [self.scrollView setContentOffset:CGPointMake(scrollWidth * self.cardArray.count, 0)];
    }
    
    NSInteger page = round((self.scrollView.contentOffset.x - scrollWidth)/scrollWidth);
    self.pageControl.currentPage = page;
}

#pragma mark - <事件>
- (void)bannerScroll {
    
    CGFloat scrollWidth = self.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + scrollWidth, 0) animated:YES];
//    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentOffset.x + scrollWidth, 0, scrollWidth, self.scrollView.bounds.size.height) animated:YES];
    
    [self fixContentOffset];
    
}

- (void)onImageClicked:(UIImageView *)imageView {
    NSInteger index = imageView.tag - 100;
    NAMainCardModel *cardModel = self.cardArray[index];
    if (self.clickBlock) {
        self.clickBlock(cardModel);
    }
}

- (void)onPageControlClicked:(UIPageControl *)pageControl {
    
    CGFloat scrollWidth = self.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake((pageControl.currentPage + 1) * scrollWidth, 0) animated:YES];
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self fixContentOffset];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
