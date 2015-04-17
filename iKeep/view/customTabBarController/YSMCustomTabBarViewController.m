//
//  YSMCustomTabBarViewController.m
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMCustomTabBarViewController.h"
#import "YSMDDMenuView.h"

#import <objc/runtime.h>

/************左右menu view的frame*************/
#define LEFT_MENU_VIEW_FRAME CGRectMake(-250.0f, 20.0f, 260.0f, DEVICE_HEIGHT-20.0f)
#define RIGHT_MENU_VIEW_FRAME CGRectMake(310.0f, 20.0f, 260.0f, DEVICE_HEIGHT-20.0f)
#define SEPERAT_VIEW_FRAME CGRectMake(0.0f, 20.0f, 320.0f, DEVICE_HEIGHT-20.0f)

@interface YSMCustomTabBarViewController ()

@end

//隔挡view的关联key
static char SeperateViewAssociatedKey;
@implementation YSMCustomTabBarViewController{
    CGFloat _originalXPoint;//左右视图拖拽时的初始x坐标
    CGFloat _panGestureOriginalXPoint;//平移开始时的坐标点
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    
    //添加底部视图
    UIView *sepView = [[UIView alloc] initWithFrame:SEPERAT_VIEW_FRAME];
    sepView.alpha = 0.0f;
    sepView.backgroundColor = [UIColor darkGrayColor];
    [self addTapGesture:sepView];
    [self.view addSubview:sepView];
    objc_setAssociatedObject(self, &SeperateViewAssociatedKey, sepView, OBJC_ASSOCIATION_ASSIGN);
    
    //添加左右两个功能页
    [self createDDMenu];
}

- (void)createDDMenu
{
    //left menu
    self.leftMenuView = [[YSMDDMenuView alloc] initWithFrame:LEFT_MENU_VIEW_FRAME];
//    self.leftMenuView.backgroundColor = [UIColor redColor];
    [self addPanGesture:self.leftMenuView];
    [self.view addSubview:self.leftMenuView];
    
    //right menu
    self.rightMenuView = [[YSMDDMenuView alloc] initWithFrame:RIGHT_MENU_VIEW_FRAME];
//    self.rightMenuView.backgroundColor = [UIColor blueColor];
    [self addPanGesture:self.rightMenuView];
    [self.view addSubview:self.rightMenuView];
}

//************************************
//              左右功能视图添加拖拽手势
//************************************
#pragma mark - 左右功能视图添加拖拽手势
- (void)addPanGesture:(UIView *)view
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [view addGestureRecognizer:pan];
}

//
- (void)panGestureAction:(UIPanGestureRecognizer *)pan
{
    //开始动作
    if (pan.state == UIGestureRecognizerStateBegan) {
        _originalXPoint = pan.view.frame.origin.x;
        _panGestureOriginalXPoint = [pan locationInView:self.view].x;
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (fabs([pan locationInView:self.view].x - _panGestureOriginalXPoint) < 250.0f) {
            pan.view.frame = CGRectMake(_originalXPoint+
                                        [pan locationInView:self.view].x-
                                        _panGestureOriginalXPoint,
                                        pan.view.frame.origin.y,
                                        pan.view.frame.size.width,
                                        pan.view.frame.size.height);
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (fabs(pan.view.frame.origin.x - _originalXPoint) > 60.0f) {
            CGFloat endXPoint = 0.0f;
            BOOL sepFlag = YES;
            if (_originalXPoint == -250.0f) {
                endXPoint = 0.0f;
            } else if (_originalXPoint == 0.0f){
                endXPoint = -250.0f;
                sepFlag = NO;
            } else if (_originalXPoint == 60.0f){
                endXPoint = 310.0f;
                sepFlag = NO;
            } else if (_originalXPoint == 310.0f){
                endXPoint = 60.0f;
            }
            
            //滑动view
            [UIView animateWithDuration:0.2 animations:^{
                pan.view.frame = CGRectMake(endXPoint,
                                            pan.view.frame.origin.y,
                                            pan.view.frame.size.width,
                                            pan.view.frame.size.height);
            }];
            
            [self showSeperateView:sepFlag belowSubView:pan.view];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                pan.view.frame = CGRectMake(_originalXPoint,
                                            pan.view.frame.origin.y,
                                            pan.view.frame.size.width,
                                            pan.view.frame.size.height);
            }];
        }
    }
}

//************************************
//              隔离视图点击事件
//************************************
#pragma mark - 隔离视图点击事件
- (void)addTapGesture:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tap];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap
{
    if (self.leftMenuView.frame.origin.x >= 0.0f) {
        [UIView animateWithDuration:0.2 animations:^{
            self.leftMenuView.frame = CGRectMake(-250.0f,
                                                 self.leftMenuView.frame.origin.y,
                                                 self.leftMenuView.frame.size.width,
                                                 self.leftMenuView.frame.size.height);
        }];
        [self showSeperateView:NO belowSubView:tap.view];
        return;
    }
    
    if (self.rightMenuView.frame.origin.x <= 60.0f) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.rightMenuView hiddenKeyboard];
            self.rightMenuView.frame = CGRectMake(310.0f,
                                                 self.rightMenuView.frame.origin.y,
                                                 self.rightMenuView.frame.size.width,
                                                 self.rightMenuView.frame.size.height);
        }];
        [self showSeperateView:NO belowSubView:tap.view];
    }
}

//************************************
//              隔挡view放到指定view前或最后
//************************************
- (void)showSeperateView:(BOOL)flag belowSubView:(UIView *)aboveView
{
    //取得隔挡view
    UIView *sepView = objc_getAssociatedObject(self, &SeperateViewAssociatedKey);
    
    if (flag) {
        [self.view insertSubview:sepView belowSubview:aboveView];
        [UIView animateWithDuration:0.2 animations:^{
            sepView.alpha = 0.8f;
        }];
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        sepView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view sendSubviewToBack:sepView];
        }
    }];
}

//************************************
//      为左侧功能视图添加功能按钮
//************************************
#pragma mark - 为左侧功能视图添加功能按钮
- (void)createLeftMenuButton:(NSArray *)array
{
    if (array == nil) {
        return;
    }
    
    if ([array count] <= 0) {
        return;
    }
    
    [self.leftMenuView createLeftMenuButton:array];
}

//左侧功能菜单按钮事件
- (void)setLeftMenuCallBackAction:(BLOCK_DDMENU_CALLBACK_ACTION)action
{
    self.leftMenuView.action = action;
    self.rightMenuView.action = action;
}

//************************************
//      弹出提醒框
//************************************
#pragma mark - 弹出提醒框
- (void)showAlertMessage:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:TITLE_ALERTVIEW_CONFIRM_BUTTON otherButtonTitles:nil, nil];
    [aler show];
}

//************************************
//      显示/隐藏功能菜单
//************************************
#pragma mark - 显示/隐藏功能菜单
- (void)showDDMenu:(BOOL)flag andType:(DDMENU_TYPE)menuType
{
    if (menuType == LeftDDMenu) {
        [self showLeftDDMenu:flag];
        return;
    }
    
    if (menuType == RightDDMenu) {
        [self showRightDDMenu:flag];
        return;
    }
}

- (void)showLeftDDMenu:(BOOL)flag
{
    CGFloat xpoint = 0.0f;
    if (!flag) {
        xpoint = -250.0f;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.leftMenuView.frame = CGRectMake(xpoint, self.leftMenuView.frame.origin.y, self.leftMenuView.frame.size.width, self.leftMenuView.frame.size.height);
    }];
    
    [self showSeperateView:flag belowSubView:self.leftMenuView];
}

//右侧视图显示/隐藏
- (void)showRightDDMenu:(BOOL)flag
{
    CGFloat xpoint = 60.0f;
    if (!flag) {
        xpoint = 310.0f;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        if (xpoint >= 300.0f) {
            [self.rightMenuView hiddenKeyboard];
        }
        self.rightMenuView.frame = CGRectMake(xpoint,
                                              self.rightMenuView.frame.origin.y,
                                              self.rightMenuView.frame.size.width,
                                              self.rightMenuView.frame.size.height);
    }];
    
    [self showSeperateView:flag belowSubView:self.rightMenuView];
}

//************************************
//          通知左/右功能视图相关事件
//************************************
#pragma mark - 通知左/右功能视图更新
- (void)updateRightMenuWithvCardModel:(YSMvCardDataModel *)model
{
    [self.rightMenuView updateRightMenuWithvCard:model];
}

@end
