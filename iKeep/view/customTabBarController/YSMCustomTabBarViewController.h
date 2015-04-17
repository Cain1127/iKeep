//
//  YSMCustomTabBarViewController.h
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSMDDMenuView;
@interface YSMCustomTabBarViewController : UITabBarController

@property (nonatomic,strong) YSMDDMenuView *leftMenuView;
@property (nonatomic,strong) YSMDDMenuView *rightMenuView;

//************************************
//         为左侧功能视图添加功能按钮
//************************************
- (void)createLeftMenuButton:(NSArray *)array;
- (void)setLeftMenuCallBackAction:(BLOCK_DDMENU_CALLBACK_ACTION)action;

//************************************
//      弹出提醒框
//************************************
- (void)showAlertMessage:(NSString *)title andMessage:(NSString *)message;

//************************************
//      显示/隐藏功能菜单
//************************************
- (void)showDDMenu:(BOOL)flag andType:(DDMENU_TYPE)menuType;

//************************************
//          通知左/右功能视图相关事件
//************************************
- (void)updateRightMenuWithvCardModel:(YSMvCardDataModel *)model;

@end
