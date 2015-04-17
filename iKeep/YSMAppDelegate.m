//
//  YSMAppDelegate.m
//  iKeep
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMAppDelegate.h"
#import "YSMiKeepLoginRootViewController.h"
#import "YSMiKeepGuideViewController.h"
#import "YSMXMPPManager.h"

@implementation YSMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
/*************************************************************/
//                 XMPP服务器连接
/*************************************************************/
#pragma mark - XMPP服务器连接
#if 1
    YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
    [manager connectToServer:XMPP_SERVER_HOST andDomain:XMPP_SERVER_DOMAIN successCallBalk:^{
        NSLog(@"%@",MESSAGE_XMPPCONNECTED_SUCCESS);
    } failCallBack:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.message = MESSAGE_XMPPCONNECTED_FAIL;
        [alertView addButtonWithTitle:TITLE_XMPPCONNECTED_CANCELBUTTON];
        [alertView show];
    }];
#endif
    
    /*************************************************************/
    //                      创建主界面
    /*************************************************************/
#pragma mark - 创建主界面
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults valueForKey:USER_BASIX_INFO__ROOT_DICTIONARY];
    NSString *isFirstUse = [dict valueForKey:USER_BASIX_INFO__ISFIRSRUSE];
//    [userDefaults removeObjectForKey:USER_BASIX_INFO__ROOT_DICTIONARY];
    
    //是否第一次登录
    if (nil == isFirstUse) {
        //第一次登录显示指引页
        YSMiKeepGuideViewController *guideView = [[YSMiKeepGuideViewController
                                                   alloc] init];
        self.window.rootViewController = guideView;
        guideView.view.alpha = 0.1f;
        [UIView animateWithDuration:0.3 animations:^{
            guideView.view.alpha = 1.0f;
        }];
    } else {
        //不是第一次登录，进入广告页
        YSMiKeepLoginRootViewController *loginView =
        [[YSMiKeepLoginRootViewController alloc] init];
        UINavigationController *navCon = [[UINavigationController alloc]
                                          initWithRootViewController:loginView];
        [loginView.navigationController setNavigationBarHidden:YES];
        self.window.rootViewController = navCon;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
    [manager disConnnectServer:NO];
}

@end
