//
//  YSMBlockActionButton.h
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSMButtonStyleDataModel.h"

@interface UIButton (YSMBlockActionButton)

+ (UIButton *)createYSMBlockActionButton:(CGRect)frame andTitle:(NSString *)title andCallBalk:(BLOCK_BUTTON_ACTION)action;

+ (UIButton *)createYSMBlockActionButton:(CGRect)frame andTitle:(NSString *)title andStyle:(YSMButtonStyleDataModel *)buttonStyle andCallBalk:(BLOCK_BUTTON_ACTION)action;

@end

@interface YSMBlockActionButton : UIButton

@property (copy,nonatomic) BLOCK_BUTTON_ACTION action;

- (void)setButtonStyle:(YSMButtonStyleDataModel *)buttonStyle;

@end
