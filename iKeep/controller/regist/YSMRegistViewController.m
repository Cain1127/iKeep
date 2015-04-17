//
//  YSMRegistViewController.m
//  iKeep
//
//  Created by mac on 14-10-21.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMRegistViewController.h"
#import "YSMBlockActionButton.h"
#import "YSMBlockActionImageView.h"
#import "YSMRegistUserDataModel.h"
#import "YSMXMPPManager.h"
#import "YSMiKeepLoginMainViewController.h"

#import <objc/runtime.h>

@interface YSMRegistViewController ()

@end

@implementation YSMRegistViewController

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
    
    //创建UI
    [self createRegistViewUI];
}

- (void)createRegistViewUI
{
    //text field
    UITextField *countField = [[UITextField alloc] initWithFrame:CGRectMake(30.0f, 10.0f, 260.0f, 44.0f)];
    countField.backgroundColor = [UIColor whiteColor];
    countField.delegate = self;
    countField.placeholder = TITLE_REGIST_VIEW_COUNTTEXTFIELD_PLACEHOLDER;
    [countField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    countField.layer.borderColor = [DEDEFAULT_FORWARDGROUND_COLOR CGColor];
    countField.layer.borderWidth = 1;
    [self.mainShowView addSubview:countField];
    
    UITextField *keyField = [[UITextField alloc] initWithFrame:CGRectMake(30.0f, 64.0f, 260.0f, 44.0f)];
    keyField.backgroundColor = [UIColor whiteColor];
    keyField.delegate = self;
    keyField.placeholder = TITLE_REGIST_VIEW_KEYWORLD_TEXTFIELD_PLACEHOLDER;
    keyField.secureTextEntry = YES;
    keyField.layer.borderColor = [DEDEFAULT_FORWARDGROUND_COLOR CGColor];
    keyField.layer.borderWidth = 1;
    [keyField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.mainShowView addSubview:keyField];
    
    UITextField *keyConfirmField = [[UITextField alloc] initWithFrame:CGRectMake(30.0f, 118.0f, 260.0f, 44.0f)];
    keyConfirmField.backgroundColor = [UIColor whiteColor];
    keyConfirmField.delegate = self;
    keyConfirmField.placeholder = TITLE_REGIST_VIEW_CONFIRMKEY_TEXTFIELD_PLACEHOLDER;
    keyConfirmField.secureTextEntry = YES;
    keyConfirmField.layer.borderColor = [DEDEFAULT_FORWARDGROUND_COLOR CGColor];
    keyConfirmField.layer.borderWidth = 1;
    [keyConfirmField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.mainShowView addSubview:keyConfirmField];
    
    //login button
    YSMButtonStyleDataModel *buttonStyle = [[YSMButtonStyleDataModel alloc] init];
    buttonStyle.titleNormalColor = DEFAULT_BUTTON_TITLE_NORMAL_COLOR;
    buttonStyle.titleHightedColor = DEFAULT_BACKGROUND_COLOR;
    buttonStyle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    buttonStyle.borderColor = DEFAULT_BUTTON_TITLE_NORMAL_COLOR;
    UIButton *signupButton = [UIButton createYSMBlockActionButton:CGRectMake(30.0f, 172.0f, 260.0f, 44.0f) andTitle:TITLE_REGIST_VIEW_SIGNUP_BUTTON andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        //先进行数据效验
        NSString *count = countField.text;
        NSString *key = keyField.text;
        NSString *keyConfirm = keyConfirmField.text;
        
        //校验两次输入的密码：如若不一致或者为空，则不进行注册事件
        if (![self checkKeyWord:key andConfirm:keyConfirm]) {
            return;
        }
        
        YSMRegistUserDataModel *registUserModel = [[YSMRegistUserDataModel alloc] init];
        registUserModel.userName = count;
        registUserModel.keyWord = key;
        
        //校验数据：只要登录账号为空，则不允许注册
        if (![self checkRegistUserInfo:registUserModel]) {
            return;
        }
        
        //数据有效，进行注册
        YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
        [manager registCount:registUserModel successCallBack:^(YSMvCardDataModel *model) {
            [self alertWrongMessage:nil andMessage:TITLE_REGIST_SUCESS_MESSAGES];
            YSMiKeepLoginMainViewController *src = [[YSMiKeepLoginMainViewController alloc] init];
            //将登录信息填写进登录窗口
            [src showUserLoginInfo:model];
            
            //0.1秒后推进登录页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:src animated:YES];
            });
        } failCallBack:^(NSError *error) {
            [self alertWrongMessage:nil andMessage:[NSString stringWithFormat:@"%@ error:%@",TITLE_REGIST_FAIL_MESSAGES,error]];
        }];
    }];
    [self.mainShowView addSubview:signupButton];
}

#pragma mark - UITextField 点击时，重设主视图向上滑动的距离
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
#pragma mark - UITextField输入内容时，如若是输入邮箱，检验数据格式
#if 0
    if (textField.tag == TEXTFIELD_TAG_REGISTVIEW_EMAILFIELD) {
        NSString *emailRegular = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailRegularPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegular];
        BOOL isEmail = [emailRegularPredicate evaluateWithObject:textField.text];
        if (!isEmail) {
            textField.textColor = [UIColor redColor];
        } else {
            textField.textColor = [UIColor blackColor];
        }
    }
#endif
}


/*************************************************************/
//                      检验注册数据是否有效，并弹出说明信息
/*************************************************************/
#pragma mark - 数据校验
/*
    校验注册信息：
        登录账号---userName，不能为空
 */
- (BOOL)checkRegistUserInfo:(YSMRegistUserDataModel *)model
{
    if (model.userName) {
        return YES;
    }
    return NO;
}

//校验密码
- (BOOL)checkKeyWord:(NSString *)key andConfirm:(NSString *)confirmKey
{
    if (key) {
        if ([key isEqualToString:confirmKey]) {
            return YES;
        }
        
        //两次输入的密码不一致
        [self alertWrongMessage:nil andMessage:TITLE_REGIST_KEYCONFIRM_WRONG];
        return NO;
    }
    
    //密码框为空，要求输入有效密码
    [self alertWrongMessage:nil andMessage:TITLE_REGIST_KEYINPUT_WRONG];
    return NO;
}

@end
