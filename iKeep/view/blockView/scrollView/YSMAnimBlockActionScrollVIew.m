//
//  YSMAnimBlockActionScrollVIew.m
//  iKeep
//
//  Created by ysmeng on 14/11/3.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMAnimBlockActionScrollVIew.h"

@interface YSMAnimBlockActionScrollVIew (){
    NSArray *_imagesArray;//图片数组
    CGRect _showFrame;//当前显示的frame
    CGRect _leftFrame;//左边frame
    CGRect _rightFrame;//右边frame
    int _currentImageIndext;//当前图片
    UIImageView * _currentImageView;//当前图片
    UIImageView *_nextImageView;//下一个图片
}

@property (nonatomic,strong) UIPageControl *pageControl;//控件页数

@end

@implementation YSMAnimBlockActionScrollVIew

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(BLOCK_INT_ACTION)callBack
{
    if (self = [super initWithFrame:frame]) {
        if (callBack) {
            self.action = callBack;
        }
        
        //初始化三个frame
        _showFrame = CGRectMake(frame.size.width, 0.0f, frame.size.width, frame.size.height);
        _leftFrame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
        _rightFrame = CGRectMake(frame.size.width * 2.0f, 0.0f, frame.size.width, frame.size.height);
        
        //创建UI
        [self createAnimScrollViewUI];
    }
    
    return self;
}

- (void)createAnimScrollViewUI
{
    //当前显示 images view
    _currentImageView = [[UIImageView alloc] initWithFrame:_showFrame];
    [self addSubview:_currentImageView];
    
    //隐藏的image view
    _nextImageView = [[UIImageView alloc] initWithFrame:_rightFrame];
    [self addSubview:_nextImageView];
    
    //page controll
    self.pageControl = [[UIPageControl alloc]
                initWithFrame:CGRectMake(self.frame.size.width - 70.0f, self.frame.size.height - 25.0f, 60.0f, 10.0f)];
    [self addSubview:self.pageControl];
    self.pageControl.numberOfPages = 1;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.pageControl.currentPage = 0;
    
    //本身添加滑动手势
    [self addSwipGesture];
}

- (void)setImages:(NSArray *)imagesArray
{
    //判断数据
    if ([imagesArray count] < 1) {
        return;
    }
    
    //保存数据
    _imagesArray = [NSArray arrayWithArray:imagesArray];
    
    //设置当前显示图片
    _currentImageIndext = 0;
    if ([_imagesArray count] == 1) {
        return;
    }
    //当前显示图片
    _currentImageView.image = _imagesArray[_currentImageIndext];
    _nextImageView = _imagesArray[_currentImageIndext+1];
    self.pageControl.numberOfPages = [_imagesArray count];
    self.pageControl.currentPage = 0;
    
    //开启动画
    [self startImagesAnim];
}

- (void)addSwipGesture
{
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipGestureAction:)];
    [leftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:leftGesture];
    
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipGestureAction:)];
    [rightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:rightGesture];
    
    //单击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tap.numberOfTapsRequired  =1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)leftSwipGestureAction:(UISwipeGestureRecognizer *)swip
{
    if (swip.direction == UISwipeGestureRecognizerDirectionLeft) {
        if ([_imagesArray count] > 1) {
            [self timerAction];
        }
    }
}

- (void)rightSwipGestureAction:(UISwipeGestureRecognizer *)swip
{
    if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
        
        if ([_imagesArray count] < 2) {
            return;
        }
        
        _nextImageView.frame = _leftFrame;
        _nextImageView.image = _imagesArray[[self leftDirectorNextImageViewIndex]];
        [UIView animateWithDuration:0.3 animations:^{
            _nextImageView.frame = _showFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                UIImageView *tempImageView = _nextImageView;
                _nextImageView = _currentImageView;
                _currentImageView = tempImageView;
                _currentImageIndext = [self leftDirectorNextImageViewIndex];
                self.pageControl.currentPage = _currentImageIndext;
                _nextImageView.image = _imagesArray[[self rightDirectorNextImageViewIndex]];
            }
        }];
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap
{
    if (self.action) {
        self.action(_currentImageIndext);
    }
}

//*********************************
//      定时器事件
//*********************************
#pragma mark - 定时器动画
- (void)startImagesAnim
{
    //开启定时器
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction
{
    _nextImageView.frame = _rightFrame;
    [UIView animateWithDuration:0.3 animations:^{
        _nextImageView.frame = _showFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            UIImageView *tempImageView = _nextImageView;
            _nextImageView = _currentImageView;
            _currentImageView = tempImageView;
            _nextImageView.image = _imagesArray[[self rightDirectorNextImageViewIndex]];
            _currentImageIndext = [self rightDirectorNextImageViewIndex];
            self.pageControl.currentPage = _currentImageIndext;
        }
    }];
}

- (int)rightDirectorNextImageViewIndex
{
    if (_currentImageIndext == ([_imagesArray count] - 1)) {
        return 0;
    }
    
    return _currentImageIndext + 1;
}

- (int)leftDirectorNextImageViewIndex
{
    if (_currentImageIndext == 0) {
        return (int)[_imagesArray count] - 1;
    }
    
    return _currentImageIndext - 1;
}

@end
