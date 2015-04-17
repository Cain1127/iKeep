//
//  YSMMainHomeJieqiFoodRecommendViewController.h
//  iKeep
//
//  Created by ysmeng on 14/11/8.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMTurnBackViewController.h"

@interface YSMMainHomeJieqiFoodRecommendViewController : YSMTurnBackViewController

@property (nonatomic,assign) JIEQI_FOOD_TYPE foodsType;

//菜谱时需要设置背景图片的数据
- (void)loadJieqiFoodData:(NSArray *)array;

@end
