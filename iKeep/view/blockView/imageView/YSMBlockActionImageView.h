//
//  YSMBlockActionImageView.h
//  iKeep
//
//  Created by mac on 14-10-21.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YSMBlockActionImageView)

+ (UIImageView *)createYSMBlockActionImageView:(CGRect)frame andCallBack:(BLOCK_VOID_ACTION)action;

@end

@interface YSMBlockActionImageView : UIImageView

@property (nonatomic,copy) BLOCK_VOID_ACTION action;

@end
