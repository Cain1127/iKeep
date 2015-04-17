//
//  YSMAutoHidenWithStatusAndKeyboardViewController.h
//  iKeep
//
//  Created by mac on 14-10-17.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSMHUD.h"

@interface YSMAutoHidenWithStatusAndKeyboardViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *rootView;
@property (nonatomic,strong) YSMHUD *HUDView;

//弹出提示框
- (void)alertWrongMessage:(NSString *)title andMessage:(NSString *)message;

- (void)alertMessage:(NSString *)title andMessage:(NSString *)message andDelegate:(id /*<UIAlertViewDelegate>*/)delegate andCancel:(NSString *)cancel andOther:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
