//
//  YSMHealthyViewController.h
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMvCardTopicViewController.h"

//代理
@protocol YSMHealthyViewControllerDelegate <NSObject>

- (void)showStepCountWithDelegate:(int)stepCount;

@end

@interface YSMHealthyViewController : YSMvCardTopicViewController

@end
