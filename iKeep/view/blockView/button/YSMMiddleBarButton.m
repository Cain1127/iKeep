//
//  YSMMiddleBarButton.m
//  iKeep
//
//  Created by ysmeng on 14/11/2.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMMiddleBarButton.h"

@implementation UIButton (YSMMiddleBarButton)

+ (UIButton *)createMiddleBarButton:(CGRect)frame andTitle:(NSString *)title andCallBack:(BLOCK_BUTTON_ACTION)callBack
{
    YSMMiddleBarButton *button = [[YSMMiddleBarButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.action = callBack;
    
    return button;
}

@end

@implementation YSMMiddleBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:BLUE_BUTTON_TITLECOLOR_HIGHTLIGHTED forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)buttonAction:(UIButton *)button
{
    if (self.action) {
        self.action(button);
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.backgroundColor = BLUE_BUTTON_TITLECOLOR_HIGHTLIGHTED;
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
