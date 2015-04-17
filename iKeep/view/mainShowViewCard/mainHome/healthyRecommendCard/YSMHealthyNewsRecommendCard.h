//
//  YSMHealthyNewsRecommendCard.h
//  iKeep
//
//  Created by ysmeng on 14/10/30.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSMHealthyNewsRecommendCard : UIImageView

@property (nonatomic,copy) BLOCK_NSSTRING_ACTION alertMessage;//弹出提示信息
@property (nonatomic,copy) BLOCK_ID_ACTION showRecommendVC;//推出推荐页面

@end
