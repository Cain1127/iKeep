//
//  YSMBlockActionPageControl.h
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPageControl (YSMBlockActionPageControl)

+ (UIPageControl *)createBlockActionPageControl:(CGRect)frame andCallBalk:(BLOCK_PAGE_CONTROL_ACTION)action;

@end

@interface YSMBlockActionPageControl : UIPageControl

@property (nonatomic,copy) BLOCK_PAGE_CONTROL_ACTION action;

@end
