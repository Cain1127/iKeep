//
//  YSMNavigationBar.m
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMNavigationBar.h"
#import "YSMBlockActionButton.h"

#import <objc/runtime.h>

/*导航栏中所有视图的坐标*/
#define VIEW_YPOINT 27.0f
#define VIEW_HEGHT 30.0f
#define LEFT_VIEW_XPOINT 15.0f
#define RIGHT_VIEW_XPOINT 265.0f
#define RIGHT_VIEW_YPOINT 22.0f
#define LEFT_VIEW_WIDTH 30.0f
#define RIGHT_VIEW_WIDTH 40.0f
#define MIDDLE_LEFT_VIEW_XPOINT 40.0f
#define MIDDLE_LEFT_VIEW_WIDTH 50.0f
#define MIDDLE_VIEW_XPOINT 80.0f
#define MIDDLE_VIEW_WIDTH 160.0f
#define MIDDLE_RIGHT_VIEW_XPOINT 205.0f
#define MIDDLE_RIGHT_VIEW_WIDTH 45.0f

//frame
#define LEFT_VIEW_FRAME CGRectMake(LEFT_VIEW_XPOINT,VIEW_YPOINT,LEFT_VIEW_WIDTH,VIEW_HEGHT)
#define RIGHT_VIEW_FRAME CGRectMake(RIGHT_VIEW_XPOINT,RIGHT_VIEW_YPOINT,RIGHT_VIEW_WIDTH,RIGHT_VIEW_WIDTH)
#define MIDDLE_VIEW_FRAME CGRectMake(MIDDLE_VIEW_XPOINT,RIGHT_VIEW_YPOINT,MIDDLE_VIEW_WIDTH,RIGHT_VIEW_WIDTH)
#define MIDDLE_LEFT_VIEW_FRAME CGRectMake(MIDDLE_LEFT_VIEW_XPOINT,VIEW_YPOINT,MIDDLE_LEFT_VIEW_WIDTH,VIEW_HEGHT)
#define MIDDLE_RIGHT_VIEW_FRAME CGRectMake(MIDDLE_RIGHT_VIEW_XPOINT,VIEW_YPOINT,MIDDLE_RIGHT_VIEW_WIDTH,VIEW_HEGHT)

//各个view使用的关联key
static char LeftViewAssociatedKey;
static char RightViewAssociatedKey;
static char MiddleViewAssociatedKey;
static char MiddleLeftViewAssociatedKey;
static char MiddleRightViewAssociatedKey;
static char MessageCountTipsKey;
@implementation YSMNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        self.userInteractionEnabled = YES;
        
        //消息提醒
        UIButton *messagesCount = [UIButton buttonWithType:UIButtonTypeCustom];
        messagesCount.frame = CGRectMake(40.0f, 23.0f, 20.0f, 20.0f);
        messagesCount.hidden = YES;
        messagesCount.backgroundColor = [UIColor redColor];
        [messagesCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [messagesCount setTitle:@"0" forState:UIControlStateNormal];
        messagesCount.layer.cornerRadius = messagesCount.frame.size.height / 2.0f;
        [self addSubview:messagesCount];
        objc_setAssociatedObject(self, &MessageCountTipsKey, messagesCount, OBJC_ASSOCIATION_ASSIGN);
        self.showMessageTips = ^(int num){
            if (num > 0) {
                messagesCount.hidden = NO;
                [messagesCount setTitle:[NSString stringWithFormat:@"%d",num] forState:UIControlStateNormal];
            }
        };
    }
    return self;
}

- (void)setbackgroundImage:(UIImage *)image
{
    self.image = image;
}

- (void)setNavigationBarLeftView:(UIView *)view
{
    //清除
    [self removeBarItem:navigationBarLeftView];
    if (nil == view) {
        return;
    }
    view.frame = LEFT_VIEW_FRAME;
    [self addSubview:view];
    objc_setAssociatedObject(self, &LeftViewAssociatedKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNavigationBarTurnBackButton:(BLOCK_VOID_ACTION)action
{
    //返回按钮
    YSMButtonStyleDataModel *buttonStyle = [[YSMButtonStyleDataModel alloc] init];
    buttonStyle.imagesNormal = IMAGE_TURNBACK_DEFAULT_NORMAL;
    buttonStyle.imagesHighted = IMAGE_TURNBACK_DEFAULT_HIGHTLIGHTED;
    UIButton *button = [UIButton createYSMBlockActionButton:LEFT_VIEW_FRAME andTitle:nil andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        if (self.superview) {
            action();
        }
    }];
    [self setNavigationBarLeftView:button];
}

- (void)setNavigationBarMiddleLeftView:(UIView *)view
{
    //清除
    [self removeBarItem:navigationBarMiddleLeftView];
    
    view.frame = MIDDLE_LEFT_VIEW_FRAME;
    [self addSubview:view];
    objc_setAssociatedObject(self, &MiddleLeftViewAssociatedKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNavigationBarMiddleView:(UIView *)view
{
    //清除
    [self removeBarItem:navigationBarMiddleView];
    
    view.frame = MIDDLE_VIEW_FRAME;
    [self addSubview:view];
    objc_setAssociatedObject(self, &MiddleViewAssociatedKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNavigationBarMiddleRightView:(UIView *)view
{
    //清除
    [self removeBarItem:navigationBarMiddleRightView];
    
    view.frame = MIDDLE_RIGHT_VIEW_FRAME;
    [self addSubview:view];
    objc_setAssociatedObject(self, &MiddleRightViewAssociatedKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNavigationBarRightView:(UIView *)view
{
    //清除
    [self removeBarItem:navigationBarRightView];
    if (view.frame.size.width <= 80.0f && view.frame.size.height <= 30) {
        view.frame = CGRectMake(self.frame.size.width - view.frame.size.width - 10.0f, VIEW_YPOINT, view.frame.size.width, view.frame.size.height);
    } else {
        view.frame = RIGHT_VIEW_FRAME;
    }
    [self addSubview:view];
    objc_setAssociatedObject(self, &RightViewAssociatedKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNavigationBarRightSettingButton
{
    
}

- (void)setNavigationBarMiddleTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:MIDDLE_VIEW_FRAME];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [self setNavigationBarMiddleView:titleLabel];
}

- (void)setNavigationBarMiddleLeftTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:MIDDLE_LEFT_VIEW_FRAME];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [self setNavigationBarMiddleLeftView:titleLabel];
}

#pragma mark - 清除对应的左中右子视图
- (void)removeBarItem:(NAVIGATION_BAR_VIEW_TYPE)typeView
{
    /*
     navigationBarLeftView = 0,
     navigationBarRightView,
     navigationBarMiddleView,
     navigationBarMiddleLeftView,
     navigationBarMiddleRightView
     
     static char LeftViewAssociatedKey;
     static char RightViewAssociatedKey;
     static char MiddleViewAssociatedKey;
     static char MiddleLeftViewAssociatedKey;
     static char MiddleRightViewAssociatedKey;
     */
    UIView *view = nil;
    switch (typeView) {
        case navigationBarLeftView:
            view = objc_getAssociatedObject(self, &LeftViewAssociatedKey);
            break;
            
        case navigationBarRightView:
            view = objc_getAssociatedObject(self, &RightViewAssociatedKey);
            break;
            
        case navigationBarMiddleView:
            view = objc_getAssociatedObject(self, &MiddleViewAssociatedKey);
            break;
            
        case navigationBarMiddleLeftView:
            view = objc_getAssociatedObject(self, &MiddleLeftViewAssociatedKey);
            break;
            
        case navigationBarMiddleRightView:
            view = objc_getAssociatedObject(self, &MiddleRightViewAssociatedKey);
            break;
            
        default:
            break;
    }
    
    //清除
    if (view) {
        [view removeFromSuperview];
    }
}

@end
