//
//  YSMHealthyFoodRecommendDataModel.h
//  iKeep
//
//  Created by ysmeng on 14/11/8.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSMHealthyFoodRecommendDataModel : NSObject

@property (nonatomic,copy) NSString *listID;//主题ID
@property (nonatomic,copy) NSString *name;//食材名字
@property (nonatomic,copy) NSString *foodType;//食材类型
@property (nonatomic,assign) int foodTypeColor;//类型颜色
@property (nonatomic,copy) NSString *detail;//食材说明
@property (nonatomic,copy) UIImage *foodImage;//食材图片

@end
