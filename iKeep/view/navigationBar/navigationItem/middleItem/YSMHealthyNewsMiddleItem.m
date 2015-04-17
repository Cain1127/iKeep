//
//  YSMHealthyNewsMiddleItem.m
//  iKeep
//
//  Created by ysmeng on 14/11/2.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMHealthyNewsMiddleItem.h"
#import "YSMMiddleBarButton.h"

@interface YSMHealthyNewsMiddleItem ()

@property (nonatomic,strong) UIView *rootView;

@end

@implementation YSMHealthyNewsMiddleItem

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(BLOCK_NEWSTYPE_ACTION)callBack
{
    if (self = [super initWithFrame:frame]) {
        //保存回调action
        self.action = callBack;
        
        //创建UI
        [self createHealthyNewsMiddleItemUI];
    }
    
    return self;
}

- (void)createHealthyNewsMiddleItemUI
{
    //底视图
    self.rootView = [[UIView alloc] initWithFrame:CGRectMake(40.0f, 5.0f, 80.0f, 30.0f)];
    [self addSubview:self.rootView];
    self.rootView.layer.cornerRadius = 8.0f;
    self.rootView.layer.borderColor = [BLUE_BUTTON_TITLECOLOR_HIGHTLIGHTED CGColor];
    self.rootView.layer.borderWidth = 1.0f;
    
    //左按钮
    UIButton *leftButton = [UIButton createMiddleBarButton:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f) andTitle:@"资讯" andCallBack:^(UIButton *button) {
        //如果点击的按钮就是选择状态，则不执行
        if (button.selected) {
            return;
        }
        
        if (self.action) {
            self.action(TextHealthyNews);
        }
    }];
    leftButton.selected = YES;
    [self.rootView addSubview:leftButton];
    [leftButton addTarget:self action:@selector(middleBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //右按钮
    UIButton *rightButton = [UIButton createMiddleBarButton:CGRectMake(40.0f, 0.0f, 40.0f, 30.0f) andTitle:@"视屏" andCallBack:^(UIButton *button) {
        //如果点击时，些按钮选中状态，则不执行事件
        if (button.selected) {
            return;
        }
        
        if (self.action) {
            self.action(MediaHealthyNews);
        }
    }];
    [self.rootView addSubview:rightButton];
    [rightButton addTarget:self action:@selector(middleBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)middleBarButtonAction:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    
    for (UIButton *obj in [self.rootView subviews]) {
        obj.selected = NO;
    }
    
    button.selected = YES;
}

- (void)selectedWithIndex:(int)index
{
    if (index == 0) {
        NSArray *array = [self.rootView subviews];
        ((UIButton *)array[0]).selected = YES;
        ((UIButton *)array[1]).selected = NO;
        return;
    }
    
    if (index == 1) {
        NSArray *array = [self.rootView subviews];
        ((UIButton *)array[0]).selected = NO;
        ((UIButton *)array[1]).selected = YES;
        return;
    }
}

@end
