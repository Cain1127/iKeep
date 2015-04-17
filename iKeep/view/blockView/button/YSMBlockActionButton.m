//
//  YSMBlockActionButton.m
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMBlockActionButton.h"

@implementation UIButton (YSMBlockActionButton)

+ (UIButton *)createYSMBlockActionButton:(CGRect)frame andTitle:(NSString *)title andCallBalk:(BLOCK_BUTTON_ACTION)action
{
    /*
     UIColor *bgColor;
     UIColor *titleNormalColor;
     UIColor *titleHightedColor;
     UIColor *titleSelectedColor;
     UIColor *borderColor;
     CGFloat borderWith;
     CGFloat cornerRadio;
     NSString *imagesNormal;
     NSString *imagesHighted;
     NSString imagesSelected;
     */
    YSMButtonStyleDataModel *buttonStyle;
    buttonStyle.titleNormalColor = DEFAULT_BUTTON_TITLE_NORMAL_COLOR;
    buttonStyle.titleHightedColor = DEFAULT_BUTTON_TITLE_HIGHTED_COLOR;
    
    return [self createYSMBlockActionButton:frame andTitle:title andStyle:buttonStyle andCallBalk:action];
}

+ (UIButton *)createYSMBlockActionButton:(CGRect)frame andTitle:(NSString *)title andStyle:(YSMButtonStyleDataModel *)buttonStyle andCallBalk:(BLOCK_BUTTON_ACTION)action
{
    YSMBlockActionButton *button = [[YSMBlockActionButton alloc] initWithFrame:frame];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (action) {
        button.action = action;
    }
    
    //设置风格
    [button setButtonStyle:buttonStyle];
    
    return button;
}

@end

@interface YSMBlockActionButton ()



@end

@implementation YSMBlockActionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化时就添加事件
        [self addTarget:self action:@selector(blockButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)blockButtonAction:(UIButton *)button
{
    if (self.action) {
        self.action(button);
    }
}

- (void)setButtonStyle:(YSMButtonStyleDataModel *)buttonStyle
{
    /*
     UIColor *bgColor;
     UIColor *titleNormalColor;
     UIColor *titleHightedColor;
     UIColor *titleSelectedColor;
     UIColor *borderColor;
     CGFloat borderWith;
     CGFloat cornerRadio;
     NSString *imagesNormal;
     NSString *imagesHighted;
     NSString imagesSelected;
     NSString *aboveImage;
     */
    if (buttonStyle.bgColor) {
        self.backgroundColor = buttonStyle.bgColor;
    }
    
    if (buttonStyle.titleNormalColor) {
        [self setTitleColor:buttonStyle.titleNormalColor
                   forState:UIControlStateNormal];
    }
    
    if (buttonStyle.titleHightedColor) {
        [self setTitleColor:buttonStyle.titleHightedColor
                   forState:UIControlStateHighlighted];
    }
    
    if (buttonStyle.titleSelectedColor) {
        [self setTitleColor:buttonStyle.titleSelectedColor
                   forState:UIControlStateSelected];
    }
    
    if (buttonStyle.borderColor) {
        self.layer.borderColor = [buttonStyle.borderColor CGColor];
    }
    
    if (buttonStyle.borderWith >= 0.5f && buttonStyle.borderWith <= 10.0f) {
        self.layer.borderWidth = buttonStyle.borderWith;
    }
    
    if (buttonStyle.imagesNormal) {
        UIImage *image = [UIImage imageNamed:buttonStyle.imagesNormal];
        [self setImage:image forState:UIControlStateNormal];
    }
    
    if (buttonStyle.imagesHighted) {
        [self setImage:[UIImage imageNamed:buttonStyle.imagesHighted]
              forState:UIControlStateHighlighted];
    }
    
    if (buttonStyle.imagesSelected) {
        [self setImage:[UIImage imageNamed:buttonStyle.imagesSelected]
              forState:UIControlStateSelected];
    }
    
    if (buttonStyle.cornerRadio > 1.0f && buttonStyle.cornerRadio <= 100.0f) {
        self.layer.cornerRadius = buttonStyle.cornerRadio;
    }
    
    if (buttonStyle.titleFont) {
        self.titleLabel.font = buttonStyle.titleFont;
    }
    
    if (buttonStyle.aboveImage) {
        UIImageView *aboveImageView = [[UIImageView alloc]
                                       initWithFrame:CGRectMake(0.0f, 0.0f,
                                                        self.frame.size.width,
                                                        self.frame.size.height)];
        aboveImageView.image = [UIImage imageNamed:buttonStyle.aboveImage];
        [self addSubview:aboveImageView];
    }
}

@end
