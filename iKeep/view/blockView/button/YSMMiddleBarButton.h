//
//  YSMMiddleBarButton.h
//  iKeep
//
//  Created by ysmeng on 14/11/2.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YSMMiddleBarButton)

+ (UIButton *)createMiddleBarButton:(CGRect)frame andTitle:(NSString *)title andCallBack:(BLOCK_BUTTON_ACTION)callBack;

@end

@interface YSMMiddleBarButton : UIButton

@property (nonatomic,copy) BLOCK_BUTTON_ACTION action;

@end
