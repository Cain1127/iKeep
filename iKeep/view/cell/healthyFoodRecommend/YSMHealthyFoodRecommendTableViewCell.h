//
//  YSMHealthyFoodRecommendTableViewCell.h
//  iKeep
//
//  Created by ysmeng on 14/11/8.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSMHealthyFoodRecommendDataModel.h"

@interface YSMHealthyFoodRecommendTableViewCell : UITableViewCell

//更新UI
- (void)updateUIWithModel:(YSMHealthyFoodRecommendDataModel *)model;

@end
