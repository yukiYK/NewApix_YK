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

@property (nonatomic, copy) BannerClickedBlock clickBlock;

@property (nonatomic, strong) NSTimer *timer;
/** 是否已经在自动滚动 暂未用 */
@property (nonatomic, assign) BOOL isAnimate;
@property (nonatomic, assign) NSInteger currentPage;

// 数据源
@property (nonatomic, strong) NSArray *cardArray;
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
        
        self.clickBlock = clickBlock;
        self.currentPage = 1;
        self.cardArray = cardArray;
        [self setupSubviews];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(bannerScroll) userInfo:nil repeats:YES];
        self.timer = timer;
    }
    return self;
}

- (void)setupWithCardArray:(NSArray *)cardArray clickBlock:(BannerClickedBlock)clickBlock {
    if (!cardArray || cardArray.count < 1) return;
    
    [self stopAnimation];
    
    self.cardArray = cardArray;
    self.clickBlock = clickBlock;
    [self updateSubviews];
    
    [self startAnimation];
}

- (void)startAnimation {
    if (self.timer) return;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(bannerScroll) userInfo:nil repeats:YES];
    self.timer = timer;
}

- (void)stopAnimation {
    if (!self.timer) return;
    
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
        [self updateSubviews];
    }
    
    // pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.numberOfPages = self.cardArray.count;
    pageControl.currentPage = 0;
//    [pageControl addTarget:self action:@selector(onPageControlClicked:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)updateSubviews {
    // 移除旧subviews
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self.imageViewArray removeAllObjects];
    
    // 添加新subviews
    CGFloat cardWidth = self.bounds.size.width;
    for (int i=0;i<self.cardArray.count + 2;i++) {
        
        NAMainCardModel *cardModel = nil;
        if (i == 0) {
            cardModel = [NAMainCardModel yy_modelWithJSON:self.cardArray.lastObject];
        }
        else if (i == self.cardArray.count + 1) {
            cardModel = [NAMainCardModel yy_modelWithJSON:self.cardArray.firstObject];
        }
        else {
            cardModel = [NAMainCardModel yy_modelWithJSON:self.cardArray[i-1]];
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
    self.scrollView.contentOffset = CGPointMake(cardWidth, 0);
    
    // pageControl
    if (self.cardArray.count <= 1) {
        self.pageControl.hidden = YES;
    }
    else {
        self.pageControl.numberOfPages = self.cardArray.count;
        self.pageControl.currentPage = 0;
        CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
        self.pageControl.frame = CGRectMake((self.bounds.size.width - pageControlSize.width)/2, self.bounds.size.height - pageControlSize.height, pageControlSize.width, pageControlSize.height);
    }
}

- (void)fixContentOffset {
    
    CGFloat scrollWidth = self.bounds.size.width;
    if (self.scrollView.contentOffset.x > scrollWidth * self.cardArray.count * 1.1) {
        [self.scrollView setContentOffset:CGPointMake(scrollWidth, 0)];
    }
    else if (self.scrollView.contentOffset.x < scrollWidth * 0.9) {
        [self.scrollView setContentOffset:CGPointMake(scrollWidth * self.cardArray.count, 0)];
    }
    
    
    NSInteger page = round((self.scrollView.contentOffset.x - scrollWidth)/scrollWidth);
    self.pageControl.currentPage = page;
    // 修复可能出现的错位问题
//    if (round(self.scrollView.contentOffset.x) != scrollWidth * (page + 1)) {
//        [self.scrollView setContentOffset:CGPointMake(scrollWidth * (page + 1), 0)];
//    }
}

#pragma mark - <事件>
- (void)bannerScroll {
    
    CGFloat scrollWidth = self.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake((self.pageControl.currentPage + 2) * scrollWidth, 0) animated:YES];
//    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentOffset.x + scrollWidth, 0, scrollWidth, self.scrollView.bounds.size.height) animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_MSEC * 300)), dispatch_get_main_queue(), ^{
        [self fixContentOffset];
    });
}

- (void)onImageClicked:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 100;
    NAMainCardModel *cardModel = [NAMainCardModel yy_modelWithJSON:self.cardArray[index]];
    if (self.clickBlock) {
        self.clickBlock(cardModel);
    }
}

//- (void)onPageControlClicked:(UIPageControl *)pageControl {
//    
//    CGFloat scrollWidth = self.bounds.size.width;
//    [self.scrollView setContentOffset:CGPointMake((pageControl.currentPage + 1) * scrollWidth, 0) animated:YES];
//}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self fixContentOffset];
}


@end
