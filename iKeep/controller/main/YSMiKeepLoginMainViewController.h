//
//  YSMiKeepLoginMainViewController.h
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMTurnBackViewController.h"

@class YSMRegistUserDataModel;
@interface YSMiKeepLoginMainViewController : YSMTurnBackViewController

- (void)showUserLoginInfo:(YSMvCardDataModel *) model;
- (void)removeNavigationViewControllers;

@end
