//
//  YSMvCardTopicViewController.h
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMTopicViewController.h"

@interface YSMvCardTopicViewController : YSMTopicViewController

@property (nonatomic,copy) BLOCK_VOID_ACTION moreButtonAction;
@property (nonatomic,copy) BLOCK_VOID_ACTION iconButtonAction;
@property (nonatomic,copy) BLOCK_vCARDMODEL_ACTION notificavCardLoadSucces;

//重载vCard
- (void)reloadvCard;

@end