//
//  YSMAutoHidenWithStatusAndKeyboardViewController.m
//  iKeep
//
//  Created by mac on 14-10-17.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMAutoHidenWithStatusAndKeyboardViewController.h"

@interface YSMAutoHidenWithStatusAndKeyboardViewController ()

@end

@implementation YSMAutoHidenWithStatusAndKeyboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //HUD初始化
    self.HUDView = [[YSMHUD alloc] initWithTargetView:self.view];
    
    self.rootView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
                                                             self.view.frame.size.width,
                                                             self.view.frame.size.height)];
    self.rootView.userInteractionEnabled = YES;
    self.rootView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [self.view addSubview:self.rootView];
    
    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callingStatusBarAction:) name:UI object:nil];
}

- (void)callingStatusBarAction:(NSNotification *)notification
{
    
}

#pragma mark - 弹出提示框
//弹出提示框
- (void)alertWrongMessage:(NSString *)title andMessage:(NSString *)message
{
    [self alertMessage:title andMessage:message andDelegate:nil andCancel:TITLE_ALERTVIEW_CONFIRM_BUTTON andOther:nil, nil];
}

- (void)alertMessage:(NSString *)title andMessage:(NSString *)message andDelegate:(id /*<UIAlertViewDelegate>*/)delegate andCancel:(NSString *)cancel andOther:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - UITextFieldDelegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
