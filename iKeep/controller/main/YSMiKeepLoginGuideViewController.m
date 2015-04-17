//
//  YSMiKeepLoginGuideViewController.m
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMiKeepLoginGuideViewController.h"
#import "YSMBlockActionButton.h"
#import "YSMiKeepLoginMainViewController.h"
#import "YSMRegistViewController.h"

@interface YSMiKeepLoginGuideViewController ()

@end

@implementation YSMiKeepLoginGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //create guide UI
    [self createLoginGuideUI];
}

#pragma mark - UI 创建方法
- (void)createLoginGuideUI
{
    //default image
    UIImageView *defaultView = [[UIImageView alloc]
                                initWithFrame:CGRectMake(0.0f, 0.0f,
                                                         self.rootView.frame.size.width,
                                                         self.rootView.frame.size.height)];
    defaultView.userInteractionEnabled = YES;
    
    //根据当前设备高度，设置image show view的起始位置
    CGFloat ypointImages = self.rootView.frame.size.height / 2.0f - 20.0f;
    CGFloat ypointButton = self.rootView.frame.size.height - 100.0f;
    if (IS_PHONE568) {
        defaultView.image = [UIImage imageNamed:IMAGE_LOGINGUIDE_DEFAULT_568];
    } else {
        ypointImages = ypointImages + 15.0f;
        ypointButton = ypointButton + 20.0f;
        defaultView.image = [UIImage imageNamed:IMAGE_LOGINGUIDE_DEFAULT];
    }
    
    [self createDefaultView:defaultView andImagesPoint:ypointImages andButtonPoint:ypointButton];
    
    [self.rootView addSubview:defaultView];
}

- (void)createDefaultView:(UIView *)view andImagesPoint:(CGFloat)ypointImages andButtonPoint:(CGFloat)ypointButton
{
    //images show scrollView
    UIScrollView *imagesView = [[UIScrollView alloc]
                                initWithFrame:CGRectMake(0.0f, ypointImages,
                                                         view.frame.size.width, 120.0f)];
//    imagesView.backgroundColor = [UIColor orangeColor];
    imagesView.showsHorizontalScrollIndicator = NO;
    imagesView.showsVerticalScrollIndicator = NO;
//    imagesView.bounces = NO;
    [self loadActiveUserIcon:imagesView];
    [view addSubview:imagesView];
    
    //action button
    YSMButtonStyleDataModel *buttonModel = [[YSMButtonStyleDataModel alloc] init];
    buttonModel.borderColor = DEDEFAULT_FORWARDGROUND_COLOR;
    buttonModel.borderWith = 1;
    buttonModel.bgColor = WHITE_BUTTON_TITLE_HIGHTED_COLOR;
    buttonModel.titleSelectedColor = DEFAULT_BUTTON_TITLE_NORMAL_COLOR;
    buttonModel.titleNormalColor = DEDEFAULT_FORWARDGROUND_COLOR;
    buttonModel.titleHightedColor = DEFAULT_BUTTON_TITLE_NORMAL_COLOR;
    UIButton *yesButton = [UIButton createYSMBlockActionButton:CGRectMake(30.0f, ypointButton, 80.0f, 60.0f) andTitle:TITLE_LOGINGUIDE_VIEW_YES_BUTTON andStyle:buttonModel andCallBalk:^(UIButton *button) {
        //登录界面
        YSMiKeepLoginMainViewController *src = [[YSMiKeepLoginMainViewController alloc] init];
        [self.navigationController pushViewController:src animated:YES];
    }];
    yesButton.selected = YES;
    [view addSubview:yesButton];
    
    UIButton *noButton = [UIButton createYSMBlockActionButton:CGRectMake(120.0f, ypointButton, 80.0f, 60.0f) andTitle:TITLE_LOGINGUIDE_VIEW_NO_BUTTON andStyle:buttonModel andCallBalk:^(UIButton *button) {
        //跳转到注册页面
        YSMRegistViewController *src = [[YSMRegistViewController alloc] init];
        [self.navigationController pushViewController:src animated:YES];
    }];
    [view addSubview:noButton];
    
    //trial
    UIButton *trialButton = [UIButton createYSMBlockActionButton:CGRectMake(210.0f, ypointButton, 80.0f, 60.0f) andTitle:TITLE_LOGINGUIDE_VIEW_TRIAL_BUTTON andStyle:buttonModel andCallBalk:^(UIButton *button) {
        //跳转到试用页面
        
    }];
    [view addSubview:trialButton];
}

- (void)loadActiveUserIcon:(UIScrollView *)scrollView
{
    //login_guide_active_user01
    CGFloat width = scrollView.frame.size.height;
    CGFloat gap = 15.0f;
    CGFloat xpoint = 0.0f;
    scrollView.contentSize = CGSizeMake(width * 5.0f + 4.0f * gap, width);
    for (int i = 0; i < 5; i++) {
        UIImageView *tempImageView = [[UIImageView alloc]
                                      initWithFrame:CGRectMake(xpoint, 0.0f, width, width)];
        tempImageView.image = [UIImage imageNamed:
                               [NSString stringWithFormat:@"login_guide_active_user0%d",i+1]];
        [scrollView addSubview:tempImageView];
        xpoint = xpoint + width + gap;
    }
}

@end
