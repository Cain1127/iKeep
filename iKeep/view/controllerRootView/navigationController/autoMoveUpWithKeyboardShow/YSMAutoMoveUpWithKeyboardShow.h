//
//  YSMAutoMoveUpWithKeyboardShow.h
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMAutoHidenWithStatusAndKeyboardViewController.h"

@class YSMNavigationBar;
@interface YSMAutoMoveUpWithKeyboardShow : YSMAutoHidenWithStatusAndKeyboardViewController

@property (nonatomic,strong) YSMNavigationBar *navigationView;
@property (nonatomic,strong) UIImageView *mainShowView;

//是否打开键盘弹出及回收时的通知
- (void)addKeyboardNotification:(BOOL)flag;
- (void)addKeyboardNotificationUp:(BOOL)flag;
- (void)addKeyboardNotificationDown:(BOOL)flag;
- (void)addKeyboardNotification:(BOOL)flag andHeight:(CGFloat)height;
- (void)resetKeyboardSkipHeight:(CGFloat)height;

////////////////////////////////////////////////////////////////////////////
//                                   导航栏相关view设置消息
////////////////////////////////////////////////////////////////////////////
- (void)setNavigationViewBackgroundColor:(UIColor *)color;

- (void)setNavigationBackgroundImage:(UIImage *)image;

- (void)setNavigationBarLeftView:(UIView *)view;

- (void)setNavigationBarTurnBackButton;

- (void)setNavigationBarMiddleLeftView:(UIView *)view;

- (void)setNavigationBarMiddleView:(UIView *)view;

- (void)setNavigationBarMiddleRightView:(UIView *)view;

- (void)setNavigationBarRightView:(UIView *)view;

- (void)setNavigationBarRightSettingButton;

- (void)setNavigationBarMiddleTitle:(NSString *)title;

- (void)setNavigationBarMiddleLeftTitle:(NSString *)title;

@end
