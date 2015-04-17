//
//  YSMScrolMainlViewController.m
//  iKeep
//
//  Created by ysmeng on 14/10/30.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMScrolMainlViewController.h"

@interface YSMScrolMainlViewController ()

@end

@implementation YSMScrolMainlViewController

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
    //去掉自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //创建scrollView
    [self createScrollMainShowControllerUI];
}

- (void)createScrollMainShowControllerUI
{
    //在main show view上添加scrollview
    self.scrollView = [[UIScrollView alloc]
                       initWithFrame:CGRectMake(0.0f, 0.0f,
                                                self.mainShowView.frame.size.width,
                                                self.mainShowView.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                             self.scrollView.frame.size.height + 30.0f);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.mainShowView addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor clearColor];
}

@end
