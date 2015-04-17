//
//  YSMDDMenuView.h
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSMvCardDataModel;
@interface YSMDDMenuView : UIImageView

@property (nonatomic,copy) BLOCK_DDMENU_CALLBACK_ACTION action;//DDMenu回调block

//创建左功能视图的方法
- (void)createLeftMenuButton:(NSArray *)menuArray;

//刷新右视图
- (void)updateRightMenuWithvCard:(YSMvCardDataModel *)model;

//收键盘事件
- (void)hiddenKeyboard;

@end
