//
//  YSMTouchBlockActionTableView.m
//  iKeep
//
//  Created by ysmeng on 14/11/1.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMTouchBlockActionTableView.h"

@implementation YSMTouchBlockActionTableView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.action) {
        self.action();
    }
}

@end
