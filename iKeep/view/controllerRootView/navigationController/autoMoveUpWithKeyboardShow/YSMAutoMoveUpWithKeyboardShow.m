//
//  YSMAutoMoveUpWithKeyboardShow.m
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMAutoMoveUpWithKeyboardShow.h"
#import "YSMNavigationBar.h"

@interface YSMAutoMoveUpWithKeyboardShow (){
    CGFloat _height;//记录主视图在键盘弹出及回收时的动画高度
}

@end

@implementation YSMAutoMoveUpWithKeyboardShow

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _height = 0.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //navigation view
    self.navigationView = [[YSMNavigationBar alloc]
                                initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 64.0f)];
    [self.rootView addSubview:self.navigationView];
    
    //main show view
    self.mainShowView = [[UIImageView alloc]
                         initWithFrame:CGRectMake(0.0f, 64.0f, self.view.frame.size.width,
                                                  self.view.frame.size.height - 64.0f)];
    self.mainShowView.userInteractionEnabled = YES;
    self.mainShowView.backgroundColor = [UIColor clearColor];
    [self.rootView addSubview:self.mainShowView];
    [self.rootView sendSubviewToBack:self.mainShowView];
    
    //背景
    if (IS_PHONE568) {
        self.rootView.image = [UIImage imageNamed:IMAGE_LOGIN_MAIN_DEFAULT_BG];
    } else {
        self.rootView.image = [UIImage imageNamed:IMAGE_LOGIN_MAIN_DEFAULT_BG_568];
    }
}

#pragma mark - 键盘弹出及回收时mainview做相应处理
- (void)addKeyboardNotification:(BOOL)flag
{
    [self addKeyboardNotificationUp:flag];
    [self addKeyboardNotificationDown:flag];
}

- (void)addKeyboardNotificationUp:(BOOL)flag
{
    if (flag) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardAppearanceAction:) name:UIKeyboardWillShowNotification object:nil];
    }
}

- (void)addKeyboardNotificationDown:(BOOL)flag
{
    if (flag) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHideAction:) name:UIKeyboardWillHideNotification object:nil];
    }
}

//根据给定的高度伸缩主视图
- (void)addKeyboardNotification:(BOOL)flag andHeight:(CGFloat)height
{
    _height = height;
    [self addKeyboardNotification:flag];
}

//重设滑动高度
- (void)resetKeyboardSkipHeight:(CGFloat)height
{
    //如若原来已滑动过，则先滑动回来
    if (_height > 0.0f) {
        [self mainShowViewUpAndDownWithKeyboard:_height - height andTime:0.1f];
        _height = height;
    } else if(_height == 0.0f){
        _height = height;
        [self mainShowViewUpAndDownWithKeyboard:-height andTime:0.25f];
    }
}

- (void)keyBoardAppearanceAction:(NSNotification *)sender
{
    //上移：需要知道键盘高度和移动时间
    NSTimeInterval anTime;
    [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
    [self mainShowViewUpAndDownWithKeyboard:-_height andTime:anTime];
}

- (void)keyBoardHideAction:(NSNotification *)sender
{
    NSTimeInterval anTime;
    [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
    CGFloat tempHeight = _height;
        _height = 0.0f;
    
    [self mainShowViewUpAndDownWithKeyboard:tempHeight andTime:anTime];
}

- (void)mainShowViewUpAndDownWithKeyboard:(CGFloat)height andTime:(NSTimeInterval)time
{
    CGRect frame = CGRectMake(self.mainShowView.frame.origin.x,
                              self.mainShowView.frame.origin.y + height,
                              self.mainShowView.frame.size.width,
                              self.mainShowView.frame.size.height);
    [UIView animateWithDuration:time animations:^{
        self.mainShowView.frame = frame;
    }];
}

/////////////////////////////////////////////////////
//             导航栏相关view设置消息
/////////////////////////////////////////////////////
#pragma mark - 导航栏相关view设置
- (void)setNavigationViewBackgroundColor:(UIColor *)color
{
    self.navigationView.backgroundColor = color;
}

- (void)setNavigationBackgroundImage:(UIImage *)image
{
    [self.navigationView setbackgroundImage:image];
}

- (void)setNavigationBarLeftView:(UIView *)view
{
    [self.navigationView setNavigationBarLeftView:view];
}

- (void)setNavigationBarTurnBackButton
{
    __weak UIViewController *selfController = self;
    [self.navigationView setNavigationBarTurnBackButton:^{
        [selfController.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setNavigationBarMiddleLeftView:(UIView *)view
{
    [self.navigationView setNavigationBarMiddleLeftView:view];
}

- (void)setNavigationBarMiddleView:(UIView *)view
{
    [self.navigationView setNavigationBarMiddleView:view];
}

- (void)setNavigationBarMiddleRightView:(UIView *)view
{
    [self.navigationView setNavigationBarMiddleRightView:view];
}

- (void)setNavigationBarRightView:(UIView *)view
{
    [self.navigationView setNavigationBarRightView:view];
}

- (void)setNavigationBarRightSettingButton
{
    [self.navigationView setNavigationBarRightSettingButton];
}

- (void)setNavigationBarMiddleTitle:(NSString *)title
{
    [self.navigationView setNavigationBarMiddleTitle:title];
}

- (void)setNavigationBarMiddleLeftTitle:(NSString *)title
{
    [self.navigationView setNavigationBarMiddleLeftTitle:title];
}

#pragma mark - 点击其他地方收键盘方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *obj in [self.mainShowView subviews]) {
        if ([obj isKindOfClass:[UITextField class]]) {
            [((UITextField *)obj) resignFirstResponder];
        }
    }
}

@end
