//
//  YSMTalkViewMiddleNavigationBar.m
//  iKeep
//
//  Created by ysmeng on 14/10/31.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMTalkViewMiddleNavigationBar.h"
#import "YSMBlockActionButton.h"

@implementation UIView (YSMTalkViewMiddleNavigationBar)

+ (UIView *)createTalkViewMiddleNavigationBar:(CGRect)frame andCallBack:(BLOCK_TCMVACTIONTYPE_ACTION)callBack
{
    YSMTalkViewMiddleNavigationBar *view =
    [[YSMTalkViewMiddleNavigationBar alloc] initWithFrame:frame];
    if (callBack) {
        view.action = callBack;
    }
    return view;
}

@end

@interface YSMTalkViewMiddleNavigationBar ()

@property (nonatomic,strong) UIButton *messagesCount;//显示当前有多少条未读消息的按钮

@end

@implementation YSMTalkViewMiddleNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //创建UI
        [self createTalkViewMiddleBarUI];
    }
    
    return self;
}

- (void)createTalkViewMiddleBarUI
{
    //button above view
    UIView *aboveView = [[UIView alloc]
                         initWithFrame:CGRectMake((self.frame.size.width - 120.0f)/2.0f, 5.0f, 120.0f, 30.0f)];
    [self addSubview:aboveView];
    aboveView.layer.borderColor = [BLUE_BUTTON_TITLECOLOR_NORMAL CGColor];
    aboveView.layer.borderWidth = 2.0f;
    aboveView.layer.cornerRadius = 8.0f;
    
    //按钮风格
    YSMButtonStyleDataModel *buttonStyle = [[YSMButtonStyleDataModel alloc] init];
    buttonStyle.titleNormalColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
    buttonStyle.titleHightedColor = BLUE_BUTTON_TITLECOLOR_HIGHTLIGHTED;
    buttonStyle.titleSelectedColor = [UIColor whiteColor];
    
    //left button:160 x 40
    UIButton *leftButton = [UIButton createYSMBlockActionButton:CGRectMake(0.0f, 0.0f, 60.0f, 30.0f) andTitle:TC_MIDDLEBAR_LEFT_BUTTON andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        if (self.action) {
            self.action(TCNAMVLeftButtonActionType);
        }
    }];
    [leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [aboveView addSubview:leftButton];
    
    
    //right button
    UIButton *rightButton = [UIButton createYSMBlockActionButton:CGRectMake(60.0f, 0.0f, 60.0f, 30.0f) andTitle:TC_MIDDLEBAR_RIGHT_BUTTON andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        if (self.action) {
            self.action(TCNAMVRightButtonActionType);
        }
    }];
    [rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.selected = YES;
    rightButton.backgroundColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
    [aboveView addSubview:rightButton];
    
    self.messagesCount = [UIButton buttonWithType:UIButtonTypeCustom];
    self.messagesCount.frame = CGRectMake(130.0f, 3.0f, 20.0f, 20.0f);
    self.messagesCount.hidden = YES;
    self.messagesCount.backgroundColor = [UIColor redColor];
    [self.messagesCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.messagesCount setTitle:@"0" forState:UIControlStateNormal];
    self.messagesCount.layer.cornerRadius = self.messagesCount.frame.size.height / 2.0f;
    [self addSubview:self.messagesCount];
}

- (void)buttonAction:(UIButton *)button
{
    if (button.selected == NO) {
        return;
    }
    
    //改变按钮的风格
    for (UIButton *obj in [[self subviews][0] subviews]) {
        if (obj.selected == NO) {
            obj.selected = YES;
            obj.backgroundColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
        } else {
            obj.selected = NO;
            obj.backgroundColor = [UIColor clearColor];
        }
    }
}

//设置当前选择状态的按钮
- (void)setSelectedIndex:(NSInteger)index
{
    NSArray *array = [[self subviews][0] subviews];
    UIButton *leftButton = array[0];
    UIButton *rightButton = array[1];
    if (index == 0) {
        rightButton.selected = NO;
        rightButton.backgroundColor = [UIColor clearColor];
        leftButton.selected = YES;
        leftButton.backgroundColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
    } else if (index == 1){
        leftButton.selected = NO;
        leftButton.backgroundColor = [UIColor clearColor];
        rightButton.selected = YES;
        rightButton.backgroundColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
    }
}

//消息大于等于1条，则显示提醒按钮
- (void)alertMessageCount:(NSInteger)count
{
    if (count > 0) {
        [self.messagesCount setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
        self.messagesCount.hidden = NO;
    } else {
        [self.messagesCount setTitle:@"0" forState:UIControlStateNormal];
        self.messagesCount.hidden = YES;
    }
}

@end
