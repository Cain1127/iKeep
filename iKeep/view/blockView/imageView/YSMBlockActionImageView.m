//
//  YSMBlockActionImageView.m
//  iKeep
//
//  Created by mac on 14-10-21.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMBlockActionImageView.h"

@implementation UIImageView (YSMBlockActionImageView)

+ (UIImageView *)createYSMBlockActionImageView:(CGRect)frame andCallBack:(BLOCK_VOID_ACTION)action
{
    YSMBlockActionImageView *imageView = [[YSMBlockActionImageView alloc] initWithFrame:frame];
    imageView.action = action;
    return imageView;
}

@end

@implementation YSMBlockActionImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        [self addBlockAction];
    }
    return self;
}

- (void)addBlockAction
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap
{
    if (self.action) {
        self.action();
    }
}

@end
