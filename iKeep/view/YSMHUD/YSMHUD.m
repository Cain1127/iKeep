//
//  YSMHUD.m
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMHUD.h"
#import <objc/runtime.h>

//指示器
static char HUDIndicator;
static char MessageLabel;
@implementation YSMHUD

- (id)init
{
    return [self initWithTargetView:nil];
}

- (id)initWithTargetView:(UIView *)view
{
    if (view) {
        self = [super initWithFrame:view.frame];
        if (self) {
            self.targetView = view;
            
            [self createHUDUI];
        }
    } else {
        self = [super init];
        if (self) {
            [self createHUDUI];
        }
    }
    
    return self;
}

- (void)createHUDUI;
{
    //背景颜色
    self.backgroundColor = [UIColor whiteColor];
    
    //image
    if (IS_PHONE568) {
        self.image = [UIImage imageNamed:IMAGE_HUD_DEFAULT_BG_568];
    } else  {
        self.image = [UIImage imageNamed:IMAGE_HUD_DEFAULT_BG];
    }
    
    //indicator
    UIImageView *indicatorView = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    indicatorView.center = CGPointMake(self.center.x,self.center.y - 50.0f);
    indicatorView.image = [UIImage imageNamed:IMAGE_HUD_DEFAULT_INDICATOR];
    [self addSubview:indicatorView];
    objc_setAssociatedObject(self, &HUDIndicator, indicatorView, OBJC_ASSOCIATION_ASSIGN);
    
    //说明信息框:MessageLabel
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 44.0f)];
    messageLabel.center = CGPointMake(self.center.x,self.center.y - 50.0f);
    messageLabel.hidden = YES;
    messageLabel.textColor = [UIColor orangeColor];
    [self addSubview:messageLabel];
    objc_setAssociatedObject(self, &MessageLabel, messageLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //timer
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                      target:self
                                                    selector:@selector(indicatorAction)
                                                    userInfo:nil
                                                     repeats:YES];
    [timer fire];
}

- (void)showHUD
{
    if (self.targetView) {
        [self.targetView addSubview:self];
    }
}

- (void)hiddenHUD
{
    if ([self superview ]) {
        //停止加载并隐藏加载指示
        UIImageView *indicator = (UIImageView *)objc_getAssociatedObject(self, &HUDIndicator);
        indicator.hidden = YES;
        
        //显示加载后的信息
        UILabel *messageLabel = (UILabel *)objc_getAssociatedObject(self, &MessageLabel);
        messageLabel.text = self.hiddenMessage;
        messageLabel.hidden = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayHiddenTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self removeFromSuperview];
        });
    }
}

- (void)hiddenHUD:(CGFloat)delayTime andMessage:(NSString *)message
{
    self.delayHiddenTime = delayTime;
    self.hiddenMessage = message;
    [self hiddenHUD];
}

#pragma mark - 指示器转动方法
- (void)indicatorAction
{
    static CGFloat angle = 0.0f;
    UIImageView *indicator = (UIImageView *)objc_getAssociatedObject(self, &HUDIndicator);
    indicator.transform = CGAffineTransformMakeRotation(angle);
    angle = angle + 0.1;
}

@end
