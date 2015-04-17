//
//  YSMHealthyNewsMiddleItem.h
//  iKeep
//
//  Created by ysmeng on 14/11/2.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSMHealthyNewsMiddleItem : UIView

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(BLOCK_NEWSTYPE_ACTION)callBack;

- (void)selectedWithIndex:(int)index;

@property (nonatomic,copy) BLOCK_NEWSTYPE_ACTION action;

@end
