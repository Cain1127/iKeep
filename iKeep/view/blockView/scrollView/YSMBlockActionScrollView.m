//
//  YSMBlockActionScrollView.m
//  iKeep
//
//  Created by ysmeng on 14/11/3.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMBlockActionScrollView.h"

@implementation YSMBlockActionScrollView

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(BLOCK_INT_ACTION)callBack
{
    if (self = [self initWithFrame:frame]) {
        //保存block
        if (callBack) {
            self.action = callBack;
        }
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
