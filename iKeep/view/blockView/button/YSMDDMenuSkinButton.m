//
//  YSMDDMenuSkinButton.m
//  iKeep
//
//  Created by ysmeng on 14/10/29.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMDDMenuSkinButton.h"

@implementation UIButton (YSMDDMenuSkinButton)

+ (UIButton *)createDDMenuSkinButton:(CGRect)frame andTitle:(NSString *)title andImageName:(NSString *)imageName andCallBack:(BLOCK_BUTTON_ACTION)action
{
    YSMDDMenuSkinButton *button = [[YSMDDMenuSkinButton alloc] initWithFrame:frame];
    button.action = action;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    return button;
}

@end

@implementation YSMDDMenuSkinButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)buttonAction:(UIButton *)button
{
    if (self.action) {
        self.action(button);
    }
}

#pragma mark - 重置标题和图片的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.frame.size.width - 45.0f, 0.0f, 40.0f,
                      self.frame.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0.0f, 0.0f, 35.0f,
                      self.frame.size.height);
}

@end
