//
//  YSMBlockAlertView.h
//  iKeep
//
//  Created by ysmeng on 14/11/1.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (YSMBlockAlertView)

+ (UIAlertView *)createYSMBlockAlertViewWithTitle:(NSString *)title message:(NSString *)message andCallBack:(BLOCK_INT_ACTION)callBack cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end

@interface YSMBlockAlertView : UIAlertView <UIAlertViewDelegate>

@property (nonatomic,copy) BLOCK_INT_ACTION callBack;//回调block

@end
