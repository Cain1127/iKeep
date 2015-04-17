//
//  YSMBlockAlertView.m
//  iKeep
//
//  Created by ysmeng on 14/11/1.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMBlockAlertView.h"

@implementation UIAlertView (YSMBlockAlertView)

+ (UIAlertView *)createYSMBlockAlertViewWithTitle:(NSString *)title message:(NSString *)message andCallBack:(BLOCK_INT_ACTION)callBack cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    YSMBlockAlertView *alertView = [[YSMBlockAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:otherButtonTitles, nil];
    if (callBack) {
        alertView.callBack = callBack;
    }
    return alertView;
}

@end

@implementation YSMBlockAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil]) {
        
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.callBack) {
        self.callBack((int)buttonIndex);
    }
}

@end
