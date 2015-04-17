//
//  YSMiKeepLoginMainViewController.m
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMiKeepLoginMainViewController.h"
#import "YSMBlockActionButton.h"
#import "YSMBlockActionImageView.h"
#import "YSMRegistUserDataModel.h"
#import "YSMXMPPManager.h"
#import "YSMLoginUserDataModel.h"
#import "YSMPersonalHomePageViewController.h"
#import "YSMvCardDataModel.h"
#import "YSMXMPPManager.h"

#import <objc/runtime.h>

//关联key
static char IconImageViewKey;
static char CountFieldViewKey;
@interface YSMiKeepLoginMainViewController ()

@property (nonatomic,retain) YSMvCardDataModel *model;

@end

@implementation YSMiKeepLoginMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.model = [[YSMvCardDataModel alloc] init];
        
        //初始化个人信息
        [self loadLoginvCard];
    }
    return self;
}

- (void)loadLoginvCard
{
    //取得用户模型：ARCHIVE_PATH_SELFvCARD
    NSData *vCardData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", ARCHIVE_PATH_SELFvCARD,ARCHIVE_PATH_SELFvCARD_FILENAME]];
    if (nil == vCardData) {
        return;
    }
    self.model = [NSKeyedUnarchiver unarchiveObjectWithData:vCardData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建UI
    [self createLoginMainViewUI];
}

- (void)createLoginMainViewUI
{
    //根据键盘弹出及回收，视图自行滑动
    [self addKeyboardNotificationDown:YES];
    
    //头像
    UIImageView *iconView = [UIImageView createYSMBlockActionImageView:CGRectMake(80.0f, 10.0f, 160.0f, 160.0f) andCallBack:^{
        //头像点击事件
        NSLog(@"icon view tap action");
    }];
    if (self.model.icon) {
        iconView.image = self.model.icon;
    } else {
        iconView.image = [UIImage imageNamed:IMAGE_LOGIN_MAIN_ICON_DEFAULT_ICON];
    }
    [self.mainShowView addSubview:iconView];
    objc_setAssociatedObject(self, &IconImageViewKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    //头像修成圆image view
    UIImageView *iconBGView = [[UIImageView alloc]
                               initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 160.0f)];
    iconBGView.image = [UIImage imageNamed:IMAGE_LOGIN_MAIN_ICON_DEFAULT_BG];
    [iconView addSubview:iconBGView];
    
    //text field
    UITextField *countField = [[UITextField alloc] initWithFrame:CGRectMake(30.0f, 200.0f, 260.0f, 44.0f)];
    countField.backgroundColor = [UIColor whiteColor];
    countField.delegate = self;
    countField.placeholder = TITLE_REGIST_VIEW_COUNTTEXTFIELD_PLACEHOLDER;
    [countField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    countField.layer.borderColor = [DEDEFAULT_FORWARDGROUND_COLOR CGColor];
    countField.layer.borderWidth = 1;
    [self.mainShowView addSubview:countField];
    if (self.model.userName) {
        countField.text = self.model.userName;
    }
    objc_setAssociatedObject(self, &CountFieldViewKey, countField, OBJC_ASSOCIATION_ASSIGN);
    
    UITextField *keyField = [[UITextField alloc] initWithFrame:CGRectMake(30.0f, 254.0f, 260.0f, 44.0f)];
    keyField.backgroundColor = [UIColor whiteColor];
    keyField.delegate = self;
    keyField.placeholder = TITLE_REGIST_VIEW_KEYWORLD_TEXTFIELD_PLACEHOLDER;
    keyField.secureTextEntry = YES;
    keyField.layer.borderColor = [DEDEFAULT_FORWARDGROUND_COLOR CGColor];
    keyField.layer.borderWidth = 1;
    [keyField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.mainShowView addSubview:keyField];
    
    //login button
    YSMButtonStyleDataModel *buttonStyle = [[YSMButtonStyleDataModel alloc] init];
    buttonStyle.bgColor = DEFAULT_BUTTON_TITLE_NORMAL_COLOR;
    buttonStyle.titleNormalColor = [UIColor whiteColor];
    buttonStyle.titleHightedColor = DEDEFAULT_FORWARDGROUND_COLOR;
    UIButton *loginButton = [UIButton createYSMBlockActionButton:CGRectMake(30.0f, 308.0f, 260.0f, 44.0f) andTitle:@"Login" andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        //数据效验
        if (countField.text == nil) {
            return;
        }
        
        if (keyField.text == nil) {
            return;
        }
        
        YSMLoginUserDataModel *model = [[YSMLoginUserDataModel alloc] init];
        model.userName = countField.text;
        model.keyWords = keyField.text;
        
        YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
        [manager loginWithModel:model successCallBack:^{
            //登录成功
            YSMPersonalHomePageViewController *src =
            [[YSMPersonalHomePageViewController alloc] init];
            [self.navigationController pushViewController:src animated:YES];
            
        } failCallBack:^(NSError *error) {
            //登录失败
            [self alertWrongMessage:nil andMessage:[NSString stringWithFormat:@"%@",error]];
        }];
    }];
    [self.mainShowView addSubview:loginButton];
}

#pragma mark - 初始化用户登录信息
- (void)showUserLoginInfo:(YSMvCardDataModel *)model
{
    self.model = model;
    [self updateUIWithModel];
}

//更新UI
- (void)updateUIWithModel
{
    UITextField *count = objc_getAssociatedObject(self, &CountFieldViewKey);
    if (self.model.nickName) {
        count.text = self.model.nickName;
    }
    
    UIImageView *icon = objc_getAssociatedObject(self, &IconImageViewKey);
    if (self.model.icon) {
        icon.image = self.model.icon;
    }
}

#pragma mark - 通过点击退出按钮进入登录页面时清除控件器数组
- (void)removeNavigationViewControllers
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self setNavigationBarLeftView:nil];
        
        [[YSMXMPPManager shareXMPPManager] connectToServer:XMPP_SERVER_DOMAIN andDomain:XMPP_SERVER_HOST successCallBalk:^{
            NSLog(@"退出再连接成功");
        } failCallBack:^(NSError *error) {
            NSLog(@"退出再连接失败");
        }];
    });
}

#pragma mark - UITextField 点击时，重设主视图向上滑动的距离
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self resetKeyboardSkipHeight:(textField.frame.origin.y - 150.0f)];
}

@end
