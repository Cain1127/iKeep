//
//  YSMTalkViewMiddleNavigationBar.h
//  iKeep
//
//  Created by ysmeng on 14/10/31.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YSMTalkViewMiddleNavigationBar)

+ (UIView *)createTalkViewMiddleNavigationBar:(CGRect)frame andCallBack:(BLOCK_TCMVACTIONTYPE_ACTION)callBack;

@end

@interface YSMTalkViewMiddleNavigationBar : UIView

@property (nonatomic,copy) BLOCK_TCMVACTIONTYPE_ACTION action;

//更新选择的按钮
- (void)setSelectedIndex:(NSInteger)index;

//消息提醒
- (void)alertMessageCount:(NSInteger)count;

@end
