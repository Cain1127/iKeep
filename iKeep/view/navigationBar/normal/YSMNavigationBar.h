//
//  YSMNavigationBar.h
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSMNavigationBar : UIImageView

- (void)setbackgroundImage:(UIImage *)image;

- (void)setNavigationBarLeftView:(UIView *)view;

- (void)setNavigationBarTurnBackButton:(BLOCK_VOID_ACTION)action;

- (void)setNavigationBarMiddleLeftView:(UIView *)view;

- (void)setNavigationBarMiddleView:(UIView *)view;

- (void)setNavigationBarMiddleRightView:(UIView *)view;

- (void)setNavigationBarRightView:(UIView *)view;

- (void)setNavigationBarRightSettingButton;

- (void)setNavigationBarMiddleTitle:(NSString *)title;

- (void)setNavigationBarMiddleLeftTitle:(NSString *)title;

//显示消息提醒
@property (nonatomic,copy) BLOCK_INT_ACTION showMessageTips;

@end
