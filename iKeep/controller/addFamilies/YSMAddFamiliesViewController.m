//
//  YSMAddFamiliesViewController.m
//  iKeep
//
//  Created by ysmeng on 14/11/9.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMAddFamiliesViewController.h"
#import "YSMBlockActionButton.h"
#import "YSMXMPPManager.h"

@interface YSMAddFamiliesViewController () <UITextFieldDelegate>

@end

@implementation YSMAddFamiliesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置中间标题
    [self setNavigationBarMiddleTitle:@"添加家庭组成员"];
    
    //输入框
    UITextField *count = [[UITextField alloc] initWithFrame:CGRectMake(30.0f, 10.0f, 260.0f, 44.0f)];
    [self.mainShowView addSubview:count];
    count.delegate = self;
    count.placeholder = @"    count";
    count.autocapitalizationType = NO;
    count.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    count.layer.borderWidth = 1.0f;
    
    //按钮风格
    YSMButtonStyleDataModel *buttonStyle = [[YSMButtonStyleDataModel alloc] init];
    buttonStyle.titleNormalColor = [UIColor orangeColor];
    buttonStyle.titleHightedColor = [UIColor lightGrayColor];
    
    UIButton *add = [UIButton createYSMBlockActionButton:CGRectMake(30.0f, 64.0f, 260.0f, 44.0f) andTitle:@"添加" andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        //判断输入名是否为空
        if ((count.text == nil) || ([count.text length] < 2)) {
            return;
        }
        
        [[YSMXMPPManager shareXMPPManager] sendAddFriendRequestWithJidString:count.text andCallBack:^(NSString *string) {
            if ([string hasPrefix:count.text]) {
                [self alertWrongMessage:nil andMessage:string];
                return;
            }
            
            [self alertWrongMessage:nil andMessage:string];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    [self.mainShowView addSubview:add];
}

//收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *obj in [self.mainShowView subviews]) {
        if ([obj isKindOfClass:[UITextField class]]) {
            [((UITextField *)obj) resignFirstResponder];
        }
    }
}

@end
