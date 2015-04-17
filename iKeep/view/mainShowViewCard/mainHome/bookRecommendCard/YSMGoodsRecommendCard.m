//
//  YSMGoodsRecommendCard.m
//  iKeep
//
//  Created by ysmeng on 14/10/30.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMGoodsRecommendCard.h"

@implementation YSMGoodsRecommendCard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //用户交互
        self.userInteractionEnabled = YES;
        self.alpha = 0.6f;
        
        //背景图片
        self.image = [UIImage imageNamed:IMAGE_MAIN_HOME_MALL_CARD_DEFAULT_BG];
    }
    
    return self;
}

@end
