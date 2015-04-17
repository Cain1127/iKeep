//
//  YSMBlockActionPageControl.m
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMBlockActionPageControl.h"

@implementation UIPageControl (YSMBlockActionPageControl)

+ (UIPageControl *)createBlockActionPageControl:(CGRect)frame andCallBalk:(BLOCK_PAGE_CONTROL_ACTION)action
{
    YSMBlockActionPageControl *pageControl = [[YSMBlockActionPageControl alloc] initWithFrame:frame];
    pageControl.action = action;
    return pageControl;
}

@end

@implementation YSMBlockActionPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)pageControlAction:(YSMBlockActionPageControl *)pageControl
{
    if (self.action) {
        self.action((int)self.currentPage);
    }
}

@end
