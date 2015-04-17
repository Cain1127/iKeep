//
//  YSMPersonInfoTipsCard.m
//  iKeep
//
//  Created by ysmeng on 14/10/30.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMPersonInfoTipsCard.h"

/*---------内部frame--------*/
#define SCROLL_TIPS_VIEW_FIRST_FRAME CGRectMake(10.0f, 5.0f, self.frame.size.width - 20.0f, 30.0f)
#define SCROLL_TIPS_VIEW_SECOND_FRAME CGRectMake(10.0f, 55.0f, self.frame.size.width - 20.0f, 30.0f)
#define SCROLL_TIPS_VIEW_THIRD_FRAME CGRectMake(10.0f, -45.0f, self.frame.size.width - 20.0f, 30.0f)

@interface YSMPersonInfoTipsCard ()

@property (nonatomic,strong) UIView *yiView;//今日宜
@property (nonatomic,strong) UIView *jiView;//今日忌
@property (nonatomic,assign) BOOL aniFlag;//记录动画情况

@end

@implementation YSMPersonInfoTipsCard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.alpha = 0.4;
        self.image = [UIImage imageNamed:IMAGE_MAIN_HOME_HEALTHY_TIPS];
        
        self.aniFlag = YES;
        
        //创建提醒信息UI
        if ([self createPersonInfoTipsUI]) {
            //视图创建成功后开启定时器
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [timer fire];
        }
    }
    
    return self;
}

- (BOOL)createPersonInfoTipsUI
{
    //第一个显示view
    self.yiView = [[UIView alloc] initWithFrame:SCROLL_TIPS_VIEW_FIRST_FRAME];
    [self addSubview:self.yiView];
    
    //第一个view的说明信息
    UILabel *firstTitle = [[UILabel alloc]
                           initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 30.0f)];
    firstTitle.font = [UIFont boldSystemFontOfSize:20.0f];
    firstTitle.text = @"今日宜";
    firstTitle.textColor = [UIColor whiteColor];
    [self.yiView addSubview:firstTitle];
    
    UILabel *firstInfo = [[UILabel alloc]
                          initWithFrame:CGRectMake(70.0f, 0.0f,
                                                   self.yiView.frame.size.width - 70.0f,
                                                   30.0f)];
    firstInfo.text = @"晴明之乐，胃肠畅通";
    firstInfo.font = [UIFont systemFontOfSize:18.0f];
    firstInfo.textColor = [UIColor whiteColor];
    [self.yiView addSubview:firstInfo];
    
    //第二个显示view
    self.jiView = [[UIView alloc] initWithFrame:SCROLL_TIPS_VIEW_SECOND_FRAME];
    [self addSubview:self.jiView];
    self.jiView.alpha = 0.0f;
    
    //第二个view的说明信息
    UILabel *secondTitle = [[UILabel alloc]
                           initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 30.0f)];
    secondTitle.font = [UIFont boldSystemFontOfSize:20.0f];
    secondTitle.text = @"今日忌";
    secondTitle.textColor = [UIColor whiteColor];
    [self.jiView addSubview:secondTitle];
    
    UILabel *secondInfo = [[UILabel alloc]
                          initWithFrame:CGRectMake(70.0f, 0.0f,
                                                   self.jiView.frame.size.width - 70.0f,
                                                   30.0f)];
    secondInfo.text = @"心累于事，被逼光盘";
    secondInfo.font = [UIFont systemFontOfSize:18.0f];
    secondInfo.textColor = [UIColor whiteColor];
    [self.jiView addSubview:secondInfo];
    
    
    return YES;
}

- (void)timerAction
{
    if (self.aniFlag) {
        [UIView animateWithDuration:0.3 animations:^{
            self.yiView.frame = SCROLL_TIPS_VIEW_THIRD_FRAME;
            self.yiView.alpha = 0.0f;
            self.jiView.frame = SCROLL_TIPS_VIEW_FIRST_FRAME;
            self.jiView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            self.yiView.frame = SCROLL_TIPS_VIEW_SECOND_FRAME;
            self.aniFlag = NO;
        }];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.jiView.frame = SCROLL_TIPS_VIEW_THIRD_FRAME;
        self.jiView.alpha = 0.0f;
        self.yiView.frame = SCROLL_TIPS_VIEW_FIRST_FRAME;
        self.yiView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        self.jiView.frame = SCROLL_TIPS_VIEW_SECOND_FRAME;
        self.aniFlag = YES;
    }];
}

- (void)upateTipWithTips:(NSArray *)array
{
    ((UILabel *)([self.yiView subviews][1])).text = array[0];
    ((UILabel *)([self.jiView subviews][1])).text = array[1];
}

@end
