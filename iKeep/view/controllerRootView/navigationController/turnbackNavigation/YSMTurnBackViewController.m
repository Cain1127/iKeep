//
//  YSMTurnBackViewController.m
//  iKeep
//
//  Created by mac on 14-10-21.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMTurnBackViewController.h"

@interface YSMTurnBackViewController ()

@end

@implementation YSMTurnBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //返回按钮
    [self setNavigationBarTurnBackButton];
}

@end
