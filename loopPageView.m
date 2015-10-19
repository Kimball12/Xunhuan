//
//  loopPageView.m
//  xunhuan
//
//  Created by 韩金波 on 15/6/30.
//  Copyright (c) 2015年 韩金波-psylife. All rights reserved.
//

#import "loopPageView.h"

#define imageViewCount 3

@interface loopPageView ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIPageControl *pageControl;
@property (nonatomic,weak) NSTimer *timer;
@end

@implementation loopPageView
#pragma mark -
#pragma mark Life Cycle
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //scrollView
        UIScrollView *scrollV = [[UIScrollView alloc]init];
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.showsVerticalScrollIndicator = NO;
        scrollV.delegate = self;
        scrollV.pagingEnabled = YES;
        self.scrollView = scrollV;
        [self addSubview:scrollV];
        //添加三张imageView
        for (NSUInteger i = 0; i < imageViewCount; i++) {
            UIImageView *imageV = [[UIImageView alloc]init];
            [self.scrollView addSubview:imageV];
        }
        //pagecontrol
        UIPageControl *pageC = [[UIPageControl alloc]init];
        self.pageControl = pageC;
        [self addSubview:pageC];
        
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.scrollView.frame = CGRectMake(0, 0, w, h);
    self.pageControl.frame = CGRectMake(0, h - 37, w, 37);
    
    
    if (_isPortrait) {
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView *img = (UIImageView *)obj;
            img.frame = CGRectMake(0, idx * h, w, h);
        }];
        self.scrollView.contentSize = CGSizeMake(0, imageViewCount * self.scrollView.frame.size.height);
    }else
    {
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView *img = (UIImageView *)obj;
            img.frame = CGRectMake(idx * w, 0, w, h);
        }];
        self.scrollView.contentSize = CGSizeMake(imageViewCount * self.frame.size.width, 0);
    }
    
    self.pageControl.numberOfPages = self.imageNames.count;
    self.pageControl.currentPage = 0;
    
    [self updateImage];
    
    //    [self performSelectorInBackground:@selector(startTimer) withObject:nil];
    
}
//在layoutSubviews中做操作时，要小心，它会走至少两次，之前无形中走了两次startTimer方法，然后创建了两个timer，虽然后面我打self.timer是null，但是还有一个timer，虽然表面上没有强制指针引用它，实际上它在创建出来的时候就有强指针引用它了，然后我没法获取另一个timer并且invalidate掉，尼玛的内存泄露啊，而且他奶奶的还一直操控我的程序，好坑爹！！！
#pragma mark -
#pragma mark <UIScrollViewDelegate>
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateImage];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateImage];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat distance = 0;
        
        if (_isPortrait) {
            distance = ABS(imageView.frame.origin.y - scrollView.contentOffset.y);
        }else
        {
            distance = ABS(imageView.frame.origin.x - scrollView.contentOffset.x);
        }
        
        
        if (distance < minDistance) {
            minDistance = distance;
            page = imageView.tag;
        }
    }
    self.pageControl.currentPage = page;
}
#pragma mark -
#pragma mark private methods
- (void)updateImage
{
    for (NSUInteger i = 0; i < self.scrollView.subviews.count; i++) {
        UIImageView *imagV = self.scrollView.subviews[i];
        NSInteger index = self.pageControl.currentPage;
        if (i == 0) {
            index--;
        }else if(i == 2)
        {
            index++;
        }
        if (index < 0) {
            index = self.pageControl.numberOfPages - 1;
        }else if(index >= self.pageControl.numberOfPages )
        {
            index = 0;
        }
        imagV.tag = index;
        imagV.image = [UIImage imageNamed:self.imageNames[index]];
        
        
    }
    if (_isPortrait) {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    }else
    {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
    
    
}
- (void)next
{
    if (_isPortrait) {
        [self.scrollView setContentOffset:CGPointMake(0, 2 * self.scrollView.frame.size.height) animated:YES];
    }else
    {
        [self.scrollView setContentOffset:CGPointMake(2 * self.scrollView.frame.size.width, 0) animated:YES];
    }
    
}
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark -
#pragma mark setter and getter

-(void)setImageNames:(NSArray *)imageNames
{
    _imageNames = imageNames;
    [self startTimer];
}
@end
