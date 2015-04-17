//
//  YSMTabBarBlockActionButton.m
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMTabBarBlockActionButton.h"

@implementation UIButton (YSMTabBarBlockActionButton)

+ (UIButton *)createTabbarBlockButton:(NSString *)title andFrame:(CGRect)frame andImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage andCallBack:(BLOCK_BUTTON_ACTION)action
{
    YSMTabBarBlockActionButton *button = [[YSMTabBarBlockActionButton alloc] initWithFrame:frame];
    button.action = action;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    
    return button;
}

@end

@implementation YSMTabBarBlockActionButton{
    CGRect _originalFrame;//记录原始的frame
    CGRect _selectedFrame;//选择状态时的frame
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _originalFrame = frame;
        _selectedFrame = CGRectMake(_originalFrame.origin.x - 2.5f, _originalFrame.origin.y - 2.5f, _originalFrame.size.width + 5.0f, _originalFrame.size.height + 5.0f);
    }
    
    return self;
}

- (void)buttonAction:(UIButton *)button
{
    if (self.action) {
        self.action(button);
    }
}

//*************************************
//          重置按钮的片和标题的frame
//*************************************
#pragma mark - 重置按钮的片和标题的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.frame.size.width - 50.0f, 0.0f, 50.0f,
                      self.frame.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0.0f, 0.0f, self.frame.size.width - 80.0f,
                      self.frame.size.height);
}

//重写set selected，方便重新设置按钮的frame
- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.frame = _selectedFrame;
    } else {
        self.frame = _originalFrame;
    }
    
    [super setSelected:selected];
}

@end
