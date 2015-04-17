//
//  YSMUpdateIconViewController.h
//  iKeep
//
//  Created by ysmeng on 14/11/4.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMTurnBackViewController.h"

@interface YSMUpdateIconViewController : YSMTurnBackViewController

@property (nonatomic,copy) BLOCK_VOID_ACTION updateSuccessCallBack;

//取得图片
- (void)loadNewsIcon:(NSData *)imageData;

@end
