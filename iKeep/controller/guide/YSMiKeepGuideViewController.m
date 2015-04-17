//
//  YSMiKeepGuideViewController.m
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMiKeepGuideViewController.h"
#import <objc/runtime.h>
#import "YSMBlockActionPageControl.h"
#import "YSMBlockActionButton.h"
#import "YSMiKeepLoginRootViewController.h"

//scrollview 和pageControl的关联key
static char GuideUserAppButtonKey;
static char GuidePageViewKey;
@interface YSMiKeepGuideViewController () <UIScrollViewDelegate> {
    NSMutableArray *_guideImagesArray;//指导页的图片数组
}

@end

@implementation YSMiKeepGuideViewController

#pragma mark - 初始化相关方法
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //初始化数据
        [self initGuideImageData];
        
        //延迟执行UI创建
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //创建自定义视图
            [self createGuideUI];
        });
    }
    return self;
}

- (void)initGuideImageData
{
    //初始化指引页数组
    _guideImagesArray = [[NSMutableArray alloc] init];
    
    //取得图片数组
    NSString *path = [[NSBundle mainBundle] pathForResource:PLIST_GUIDE_INFO ofType:PIST_FILE_TYPE];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *guideImageArray = [dict valueForKey:PLIST_KEY_GUIDE_IMAGES_ARRAY];
    
    [_guideImagesArray addObjectsFromArray:guideImageArray];
}

#pragma mark - view加载方法
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)createGuideUI
{
    //scroll view：用业显示图片
    __block UIScrollView *showScrollView = [[UIScrollView alloc]
                                    initWithFrame:CGRectMake(0.0f, 20.0f,
                                                             self.view.frame.size.width,
                                                             self.view.frame.size.height - 20.0f)];
    showScrollView.showsHorizontalScrollIndicator = NO;
    showScrollView.showsVerticalScrollIndicator = NO;
    showScrollView.bounces = NO;
    showScrollView.pagingEnabled = YES;
    showScrollView.delegate = self;
    [self addGuideImages:showScrollView];
    [self.rootView addSubview:showScrollView];
    
    //page control：页面控件器
    UIPageControl *pageControl = [UIPageControl createBlockActionPageControl:CGRectMake((self.view.frame.size.width - 80.0f)/2.0f, self.view.frame.size.height - 35.0f, 80.0f, 30.0f) andCallBalk:^(int page){
        [UIView animateWithDuration:0.3 animations:^{
            showScrollView.contentOffset = CGPointMake(showScrollView.frame.size.width * page, 0.0f);
            
            if (page == 2) {
                //显示试用按钮
                [self showUserAppButton:YES];
            } else {
                [self showUserAppButton:NO];
            }
        }];
    }];
    pageControl.numberOfPages = [_guideImagesArray count];
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = DEDEFAULT_FORWARDGROUND_COLOR;
    [self.rootView addSubview:pageControl];
    
    //关联：将pageControl关联，方便scrollview减速时个性page的当前页
    objc_setAssociatedObject(self, &GuidePageViewKey, pageControl, OBJC_ASSOCIATION_ASSIGN);
    
    //按钮:GuideUserAppButtonKey，在指引页到达第三页时，获取按钮，并显示出来
    YSMButtonStyleDataModel *buttonStyle = [[YSMButtonStyleDataModel alloc] init];
    buttonStyle.bgColor = DEDEFAULT_FORWARDGROUND_COLOR;
    buttonStyle.cornerRadio = 10.0f;
    buttonStyle.titleNormalColor = DEFAULT_BUTTON_TITLE_NORMAL_COLOR;
    buttonStyle.titleHightedColor = DEFAULT_BACKGROUND_COLOR;
    UIButton *button = [UIButton createYSMBlockActionButton:CGRectMake(40.0f, self.view.frame.size.height - 120.0f, 240.0f, 44.0f) andTitle:TITLE_USEAPP_BUTTON andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        YSMiKeepLoginRootViewController *src = [[YSMiKeepLoginRootViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:src];
        [src.navigationController setNavigationBarHidden:YES];
        src.view.frame = CGRectMake(self.view.frame.size.width, 0.0f,
                                    self.view.frame.size.width,
                                    self.view.frame.size.height);
        [UIView animateWithDuration:0.5 animations:^{
            [[UIApplication sharedApplication] keyWindow].rootViewController = nav;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.view removeFromSuperview];
                
                //将应用的使用次数保存进NSUserDefault中
#ifdef __CHANGEISFIRSTUSE__
                [self saveUseInfo];
#endif
            }
        }];
    }];
    button.alpha = 0.0f;
    button.userInteractionEnabled = NO;
    objc_setAssociatedObject(self, &GuideUserAppButtonKey, button, OBJC_ASSOCIATION_ASSIGN);
    [self.rootView addSubview:button];
}

- (void)addGuideImages:(UIScrollView *)scrollView
{
    if (!(0 < [_guideImagesArray count])) {
        NSLOG_DATA_ERROR_DEFINE([self class],@"addGuideImages",@"_guideImagesArray");
        return;
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [_guideImagesArray count],
                                        scrollView.frame.size.height);
    
    //添加图片
    int i = 0;
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    for (NSString *imageName in _guideImagesArray) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0.0f, width, height)];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        //重置i
        i++;
    }
}

#pragma mark - 保存用户使用本应用的状态
//方便下次进来时，不再是第一次使用
- (void)saveUseInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //USER_BASIX_INFO__ROOT_DICTIONARY
    //USER_BASIX_INFO__ISFIRSRUSE
    NSDictionary *rootDict = [userDefaults valueForKey:USER_BASIX_INFO__ROOT_DICTIONARY];
    NSMutableDictionary *rootDictNew;
    if (nil == rootDict || 0 == [rootDict count]) {
        rootDictNew = [[NSMutableDictionary alloc] init];
    } else {
        rootDictNew = [[NSMutableDictionary alloc] initWithDictionary:rootDict];
    }
    
    NSString *isFirstUse = [rootDictNew valueForKey:USER_BASIX_INFO__ISFIRSRUSE];
    if (nil == isFirstUse) {
        isFirstUse = USER_BASIX_INFO__ISFIRSRUSE_INFO;
    }
    
    [rootDictNew setObject:isFirstUse forKey:USER_BASIX_INFO__ISFIRSRUSE];
    [userDefaults setObject:rootDictNew forKey:USER_BASIX_INFO__ROOT_DICTIONARY];
}

#pragma mark - UIScrollViewDelegate method
//当减速时，同步更改page control
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIPageControl *pageControl = (UIPageControl *)objc_getAssociatedObject(self, &GuidePageViewKey);
    pageControl.currentPage = page;
    
    if (page == 2) {
        //显示试用按钮
        [self showUserAppButton:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat oldX = 0.0f;
    static CGFloat newX = 0.0f;
    newX = scrollView.contentOffset.x;
    if (newX != oldX) {
        if (oldX < newX) {
        } else if (oldX > newX) {
            //当向左移动时，需要隐藏按钮
            [self showUserAppButton:NO];
        }
        oldX = newX;
    }
}

#pragma mark - 通过动画显示button
- (void)showUserAppButton:(BOOL)flag
{
    if (flag) {
        UIButton *button = (UIButton *)objc_getAssociatedObject(self, &GuideUserAppButtonKey);
        [UIView animateWithDuration:0.8 animations:^{
            button.alpha = 1.0f;
            button.userInteractionEnabled = YES;
        }];
        return;
    }
    
    //显示试用按钮
    UIButton *button = (UIButton *)objc_getAssociatedObject(self, &GuideUserAppButtonKey);
    button.alpha = 0.0f;
    button.userInteractionEnabled = NO;
}

@end
