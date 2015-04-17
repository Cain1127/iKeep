//
//  YSMHUD.h
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSMHUD : UIImageView

- (id)initWithTargetView:(UIView *)view;
- (void)showHUD;
- (void)hiddenHUD;
- (void)hiddenHUD:(CGFloat)delayTime andMessage:(NSString *)message;

@property (nonatomic,strong) UIView *targetView;
@property (nonatomic,assign) CGFloat delayHiddenTime;
@property (nonatomic,strong) NSString *hiddenMessage;

@end
