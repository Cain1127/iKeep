//
//  YSMDDMenuView.m
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMDDMenuView.h"
#import "YSMBlockActionButton.h"
#import "YSMDDMenuSkinButton.h"
#import "YSMTabBarBlockActionButton.h"
#import "YSMBlockActionImageView.h"
#import "YSMvCardDataModel.h"

#import <objc/runtime.h>

//左右功能视图的关联key
static char LeftMenuAssociateKey;
static char RightMenuAssociateKey;

static char IconImageViewRightKey;
static char NameLabelKey;
static char LoginLabelKey;
static char LocationAssociateKey;
static char ShareAboutMessageKey;
@interface YSMDDMenuView () <UITextFieldDelegate>

@end
@implementation YSMDDMenuView{
    CGRect _menuFrame;//功能菜单view的frame
    DDMENU_TYPE _menuType;//保存是左视图还是右视图
}

//**********************************************
//             初始化
//**********************************************
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        //根据给定的frame，设置功能view的坐标系
        [self createMenuViewFrame:frame];
        
        //添加功能视图
        [self createMenuViewUI];
    }
    
    return self;
}

#pragma mark - 设置功能view的frame
- (void)createMenuViewFrame:(CGRect)frame
{
    //设置功能view的frame
    CGFloat xpoint = frame.origin.x;
    if (xpoint < 0.0f) {
        xpoint = 0.0f;
        _menuType = LeftDDMenu;
    } else {
        xpoint = 10.0f;
        _menuType = RightDDMenu;
    }
    _menuFrame = CGRectMake(xpoint, 0.0f, 250.0f, frame.size.height);
}

//**********************************************
//             创建功能视图
//**********************************************
#pragma mark - 创建功能视图
- (void)createMenuViewUI
{
    UIImageView *menuView = [[UIImageView alloc] initWithFrame:_menuFrame];
    menuView.userInteractionEnabled = YES;
    [self addSubview:menuView];
    
    //添加单击屏蔽事件
    
    if (_menuType == LeftDDMenu) {
        [self createLeftDDMenuUI:menuView];
        return;
    }
    
    [self createRightDDMenuUI:menuView];
}

//创建左功能视图IMAGE_DDMENU_LEFT_DEFAULT_BG
#pragma mark - 左侧功能视图创建
- (void)createLeftDDMenuUI:(UIImageView *)view
{
    if (IS_PHONE568) {
        view.image = [UIImage imageNamed:IMAGE_DDMENU_LEFT_DEFAULT_BG_568];
    } else {
        view.image = [UIImage imageNamed:IMAGE_DDMENU_LEFT_DEFAULT_BG];
    }
    
    objc_setAssociatedObject(self, &LeftMenuAssociateKey, view, OBJC_ASSOCIATION_ASSIGN);
    
    //查看广告按钮
    YSMButtonStyleDataModel *buttonStyle = [[YSMButtonStyleDataModel alloc] init];
    buttonStyle.imagesNormal = IMAGE_DDMENU_LEFT_TURNBACK_ADVERT;
    UIButton *turnAvert = [UIButton createYSMBlockActionButton:CGRectMake(5.0f, view.frame.size.height - 37.0f, 44.0f, 30.0f) andTitle:nil andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        if (self.action) {
            self.action(AdvertShowActionDDMenu,LeftDDMenu);
        }
    }];
    [view addSubview:turnAvert];
    
    //主题按钮
    UIButton *skinButton = [UIButton createDDMenuSkinButton:CGRectMake(view.frame.size.width - 85.0f, view.frame.size.height - 37.0f, 80.0f, 30.0f) andTitle:TITLE_DDMENU_SKIPBUTTON andImageName:IMAGE_DDMENU_LEFT_SKIN andCallBack:^(UIButton *button) {
        if (self.action) {
            self.action(ChangeSkipTopicActionDDMenu,LeftDDMenu);
        }
    }];
    [view addSubview:skinButton];
}

//创建右功能视图
#pragma mark - 右侧功能视图创建
- (void)createRightDDMenuUI:(UIImageView *)view
{
    view.backgroundColor = [UIColor whiteColor];
    
    //头像：250-160=90
    UIImageView *iconView = [UIImageView createYSMBlockActionImageView:CGRectMake(45.0f, 30.0f, 160.0f, 160.0f) andCallBack:^{
        //头像点击事件
        if (self.action) {
            self.action(ChangeIconActionDDMenu,RightDDMenu);
        }
    }];
    iconView.image = [UIImage imageNamed:IMAGE_LOGIN_MAIN_ICON_DEFAULT_ICON];
    [view addSubview:iconView];
    objc_setAssociatedObject(self, &IconImageViewRightKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    //头像修成圆image view
    UIImageView *iconBGView = [[UIImageView alloc]
                               initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 160.0f)];
    iconBGView.image = [UIImage imageNamed:IMAGE_LOGIN_MAIN_ICON_DEFAULT_BG_WHITE];
    [iconView addSubview:iconBGView];
    
    //提醒
    UIButton *updateIconButton = [UIButton createYSMBlockActionButton:CGRectMake(180.0f, 170.0f, 60.0f, 20.0f) andTitle:@"更换头像" andCallBalk:^(UIButton *button) {
        NSLog(@"换头像按钮");
        if (self.action) {
            self.action(ChangeIconActionDDMenu,RightDDMenu);
        }
    }];
    [updateIconButton setTitleColor:BLUE_BUTTON_TITLECOLOR_NORMAL forState:UIControlStateNormal];
    [updateIconButton setTitleColor:BLUE_BUTTON_TITLECOLOR_HIGHTLIGHTED forState:UIControlStateHighlighted];
    updateIconButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:updateIconButton];
    
    //名字
    UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 200.0f, 80.0f, 20.0f)];
    [view addSubview:nickName];
    nickName.font = [UIFont systemFontOfSize:14.0f];
    nickName.textAlignment = NSTextAlignmentLeft;
    nickName.textColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
    objc_setAssociatedObject(self, &NameLabelKey, nickName, OBJC_ASSOCIATION_ASSIGN);
    
    //上次登录时间
    UILabel *lastLoginTime = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 200.0f, 150.0f, 20.0)];
    lastLoginTime.font = [UIFont systemFontOfSize:12.0f];
    lastLoginTime.textAlignment = NSTextAlignmentRight;
    lastLoginTime.textColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
    [view addSubview:lastLoginTime];
    objc_setAssociatedObject(self, &LoginLabelKey, lastLoginTime, OBJC_ASSOCIATION_ASSIGN);
    
    //所在城市
    UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 215.0f, 40.0f, 20.0f)];
    location.font = [UIFont systemFontOfSize:12.0f];
    location.textAlignment = NSTextAlignmentRight;
    location.textColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
    [view addSubview:location];
    objc_setAssociatedObject(self, &LocationAssociateKey, location, OBJC_ASSOCIATION_ASSIGN);
    
    //心情栏
    UITextField *shareAbout = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 225.0f, 230.0f, 60.0f)];
    [view addSubview:shareAbout];
    shareAbout.textColor = [UIColor orangeColor];
    objc_setAssociatedObject(self, &ShareAboutMessageKey, shareAbout, OBJC_ASSOCIATION_ASSIGN);
    
    //添加家人
    YSMButtonStyleDataModel *buttonStyle = [[YSMButtonStyleDataModel alloc] init];
    buttonStyle.titleNormalColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
    buttonStyle.titleHightedColor = BLUE_BUTTON_TITLECOLOR_HIGHTLIGHTED;
    buttonStyle.borderColor = BLUE_BUTTON_TITLECOLOR_HIGHTLIGHTED;
    buttonStyle.borderWith = 1.0f;
    UIButton *addFamilies = [UIButton createYSMBlockActionButton:CGRectMake(10.0f, 290.0f, 230.0f, 44.0f) andTitle:@"添加家庭组成员" andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        if (self.action) {
            self.action(AddFamiliesActionDDMenu,RightDDMenu);
        }
    }];
    [view addSubview:addFamilies];
    
    //退出
    UIButton *exitButton = [UIButton createYSMBlockActionButton:CGRectMake(10.0f, 339.0f, 230.0f, 44.0f) andTitle:@"退出" andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        if (self.action) {
            self.action(ExitButtonActionDDMenu,RightDDMenu);
        }
    }];
    [view addSubview:exitButton];
    
    //关联右视图
    objc_setAssociatedObject(self, &RightMenuAssociateKey, view, OBJC_ASSOCIATION_ASSIGN);
}

//**********************************************
//             为左功能视图添加功能按钮
//**********************************************
#pragma mark - 左功能视图添加功能按钮
- (void)createLeftMenuButton:(NSArray *)menuArray
{
    UIImageView *view = objc_getAssociatedObject(self, &LeftMenuAssociateKey);
    int i = 0;
    CGFloat xpoint = 80.0f;
    CGFloat ypoint = 50.0f;
    CGFloat gap = 20.0f;
    CGFloat height = 45.0f;
    CGFloat width = 125.0f;
    for (UIViewController *obj in menuArray) {
        UIButton *tempButton = [UIButton createTabbarBlockButton:obj.title andFrame:CGRectMake(xpoint, ypoint + i * ypoint + i * gap, width, height) andImage:obj.tabBarItem.image andSelectedImage:obj.tabBarItem.selectedImage andCallBack:^(UIButton *button) {
            if (self.action) {
                self.action(i+PrivateButtonActionDDMenu,LeftDDMenu);
            }
        }];
        
        //添加button action
        [tempButton addTarget:self action:@selector(leftMenuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加button
        [view addSubview:tempButton];
        if (i == 0) {
            tempButton.selected = YES;
        }
        
        i++;
    }
}

//左侧功能按钮事件
- (void)leftMenuButtonAction:(UIButton *)button
{
    //如果点击的按钮是当前按钮，直接返回
    if (button.selected) {
        if (self.action) {
            self.action(DefaultActionDDMenu,LeftDDMenu);
        }
        return;
    }
    
    //重设选中状态
    UIView *view = objc_getAssociatedObject(self, &LeftMenuAssociateKey);
    for (UIButton *obj in [view subviews]) {
        //如果遇到了第一个选中状态时，就不再循环
        if (obj.selected == YES) {
            obj.selected = NO;
            break;
        }
        
        obj.selected = NO;
    }
    button.selected = YES;
}

//**********************************************
//           更新右侧视图
//**********************************************
#pragma mark - 更新右侧视图
- (void)updateRightMenuWithvCard:(YSMvCardDataModel *)model
{
    //更新头像
    if (model.icon) {
        UIImageView *icon = objc_getAssociatedObject(self, &IconImageViewRightKey);
        icon.image = model.icon;
    }
    
    //昵称
    if (model.nickName) {
        UILabel *nickName = objc_getAssociatedObject(self, &NameLabelKey);
        nickName.text = model.nickName;
    }
    
    //最后登录时间
    if (model.lastLoginTime) {
        UILabel *lastLoginTime = objc_getAssociatedObject(self, &LoginLabelKey);
        lastLoginTime.text = [model.lastLoginTime substringToIndex:16];
    }
    
    //当前城市
    if (model.city) {
        UILabel *city = objc_getAssociatedObject(self, &LocationAssociateKey);
        city.text = model.city;
    }
    
    //说说
    if (model.shareAbout) {
        UITextField *shareAbout = objc_getAssociatedObject(self, &ShareAboutMessageKey);
        shareAbout.text = model.shareAbout;
    }
}

//**********************************************
//             收键盘事件
//**********************************************
#pragma mark - 收键盘事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField *textField = objc_getAssociatedObject(self, &ShareAboutMessageKey);
    [textField resignFirstResponder];
}

- (void)hiddenKeyboard
{
    UITextField *textField = objc_getAssociatedObject(self, &ShareAboutMessageKey);
    [textField resignFirstResponder];
}

@end
