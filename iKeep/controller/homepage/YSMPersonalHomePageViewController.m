//
//  YSMPersonalHomePageViewController.m
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMPersonalHomePageViewController.h"
#import "YSMvCardTopicViewController.h"
#import "YSMUpdateIconViewController.h"
#import "YSMiKeepLoginRootViewController.h"
#import "YSMHealthyViewController.h"
#import "YSMMainHomeViewController.h"
#import "YSMiKeepLoginMainViewController.h"
#import "YSMXMPPManager.h"
#import "YSMAppDelegate.h"
#import "YSMAddFamiliesViewController.h"
#import "YSMBlockAlertView.h"

@interface YSMPersonalHomePageViewController ()

@end

@implementation YSMPersonalHomePageViewController

//************************************************
//              初始化：包括数据初始化
//************************************************
#pragma mark - 初始化：包括数据初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //创建数据源
        if ([self createTopicViewDataSource]) {
            //创建视图
            [self createTopicView];
        }
    }
    
    return self;
}

- (BOOL)createTopicViewDataSource
{
    NSString *path = [[NSBundle mainBundle] pathForResource:PLIST_GUIDE_INFO ofType:PIST_FILE_TYPE];
    NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *topicArray = [infoDict valueForKey:PLIST_KEY_TOPIC_VIEW_ARRAY];
    
    //创建子视图
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    int i = 0;
    for (NSDictionary *tempDict in topicArray) {
        NSString *className = [tempDict valueForKey:TABBAR_DICTIONARY_KEY_CLASS];
        YSMvCardTopicViewController *tempController = [[NSClassFromString(className) alloc] init];
        tempController.title = [tempDict valueForKey:TABBAR_DICTIONARY_KEY_TITLE];
        tempController.tabBarItem.image = [UIImage imageNamed:[tempDict valueForKey:TABBAR_DICTIONARY_KEY_IMAGE]];
        tempController.tabBarItem.selectedImage = [UIImage imageNamed:[tempDict valueForKey:TABBAR_DICTIONARY_KEY_IMAGE_SELECTED]];
        
        [viewControllers addObject:tempController];
        
        //绑定主题viewController的导航栏左右按钮事件block
        tempController.moreButtonAction = ^(){
            [self showDDMenu:YES andType:LeftDDMenu];
        };
        tempController.iconButtonAction = ^(){
            [self showDDMenu:YES andType:RightDDMenu];
        };
        
        //主题页面vCard更新后，通知右侧栏更新vCard的回调
        tempController.notificavCardLoadSucces = ^(YSMvCardDataModel *model){
            //更新右侧功能栏
            [self updateRightMenuWithvCardModel:model];
        };
        
        //刷新主页步数
        
        
        i++;
    }
    
    self.viewControllers = viewControllers;
    
    return YES;
}

- (void)createTopicView
{
    //设置左功能视图
    [self createLeftMenuButton:self.viewControllers];
    __weak YSMPersonalHomePageViewController *tempClass = self;
    [self setLeftMenuCallBackAction:^(DDMENU_ACTION_TYPE actionType,DDMENU_TYPE menuType) {
        if (menuType == LeftDDMenu) {
            //左侧功能按钮点击后，左侧视图回收
            [tempClass showDDMenu:NO andType:LeftDDMenu];
            
            //判断点击的主题是否当前主题
            if (actionType == DefaultActionDDMenu) {
                return;
            }
            
            [tempClass leftMenuAction:actionType];
            return;
        }
        
        if (menuType == RightDDMenu) {
            //左侧功能按钮点击后，左侧视图回收
            [tempClass showDDMenu:NO andType:RightDDMenu];
            if (actionType == DefaultActionDDMenu) {
                return;
            }
            [tempClass rightMenuAction:actionType];
        }
    }];
}

//************************************************
//              视图加载及创建
//************************************************
#pragma mark - 视图加载及创建
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //将navigation栈中多余的viewControllers删除
    [self removeExtraViewControllers];
    
    //设置当有选择的视图是第一个
    self.selectedIndex = 0;
}

//移除navigation栈中多余的controllers
#pragma mark - 清空Navigation栈数据
- (void)removeExtraViewControllers
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    if ([viewControllers count] > 2) {
        NSArray *tempArray = @[[viewControllers lastObject]];
        self.navigationController.viewControllers = tempArray;
    }
}

//***********************************
//          左侧功能菜单点击事件
//***********************************
#pragma mark - 左侧功能菜单点击事件
- (void)leftMenuAction:(DDMENU_ACTION_TYPE)actionType
{
    switch (actionType) {
        case AdvertShowActionDDMenu:
        {
            YSMiKeepLoginRootViewController *src = [[YSMiKeepLoginRootViewController alloc] init];
            [src setLoadType:AdvertOtherLoadType];
            [self presentViewController:src animated:YES completion:^{}];
        }
            break;
            
        case ChangeSkipTopicActionDDMenu:
            NSLog(@"change skin action");
            break;
            
        case PrivateButtonActionDDMenu:
            self.selectedIndex = 0;
            break;
            
        case HomeButtonActionDDMenu:
            self.selectedIndex = 1;
            break;
            
        case HealthyButtonActionDDMenu:
            self.selectedIndex = 2;
            break;
            
        case NewsButtonActionDDMenu:
            self.selectedIndex = 3;
            break;
            
        case MallButtonActionDDMenu:
            self.selectedIndex = 4;
            break;
            
        default:
            break;
    }
}

//***********************************
//          右侧功能菜单点击事件
//***********************************
#pragma mark - 右侧功能菜单点击事件
- (void)rightMenuAction:(DDMENU_ACTION_TYPE)actionType
{
    switch (actionType) {
        case ChangeIconActionDDMenu:
        {
            YSMUpdateIconViewController *src = [[YSMUpdateIconViewController alloc]
                                            init];
            src.updateSuccessCallBack = ^(){
                //通知子视图更新vCard
                for (YSMvCardTopicViewController *obj in self.viewControllers) {
                    [obj reloadvCard];
                }
            };
            [self.navigationController pushViewController:src animated:YES];
        }
            break;
            
        case ExitButtonActionDDMenu:
        {
            //退出
            [self exitApplication];
        }
            break;
            
        case AddFamiliesActionDDMenu:
        {
            //添加好友
            YSMAddFamiliesViewController *src = [[YSMAddFamiliesViewController alloc] init];
            [self.navigationController pushViewController:src animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//退出程序
- (void)exitApplication {
    YSMAppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:0.5f animations:^{
        window.alpha = 0.0;
        window.frame = CGRectMake(0, -window.bounds.size.height, window.bounds.size.width, window.bounds.size.height);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}

//注册好友申请事件
#pragma mark - 弹出好友申请
- (void)registFriendsCallAction
{
    YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
    
    //注册好友申请事件
    [manager registFriendRequestCallBack:^(NSString *string, BLOCK_BOOL_ACTION callBack) {
        //弹出好友申请
        NSString *message = [NSString stringWithFormat:@"%@ 申请加你为好友",string];
        UIAlertView *alert = [UIAlertView createYSMBlockAlertViewWithTitle:nil message:message andCallBack:^(int num) {
            if (num == alert.cancelButtonIndex) {
                callBack(NO);
            } else {
                callBack(YES);
            }
        } cancelButtonTitle:@"拒绝" otherButtonTitles:@"添加",nil];
        [alert show];
    }];
}

@end
