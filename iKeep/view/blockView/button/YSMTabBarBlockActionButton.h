//
//  YSMTabBarBlockActionButton.h
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YSMTabBarBlockActionButton)

+ (UIButton *)createTabbarBlockButton:(NSString *)title andFrame:(CGRect)frame andImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage andCallBack:(BLOCK_BUTTON_ACTION)action;

@end

@interface YSMTabBarBlockActionButton : UIButton

@property (nonatomic,copy) BLOCK_BUTTON_ACTION action;

@end
