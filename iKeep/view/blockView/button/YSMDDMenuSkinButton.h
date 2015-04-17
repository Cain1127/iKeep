//
//  YSMDDMenuSkinButton.h
//  iKeep
//
//  Created by ysmeng on 14/10/29.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YSMDDMenuSkinButton)

+ (UIButton *)createDDMenuSkinButton:(CGRect)frame andTitle:(NSString *)title andImageName:(NSString *)imageName andCallBack:(BLOCK_BUTTON_ACTION)action;

@end

@interface YSMDDMenuSkinButton : UIButton

@property (copy,nonatomic) BLOCK_BUTTON_ACTION action;

@end
