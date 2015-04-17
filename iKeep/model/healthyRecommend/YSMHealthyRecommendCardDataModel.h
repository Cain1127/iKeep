//
//  YSMHealthyRecommendCardDataModel.h
//  iKeep
//
//  Created by ysmeng on 14/10/31.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSMHealthyRecommendCardDataModel : NSObject

@property (nonatomic,copy) NSString *sceneID;//主题ID
@property (nonatomic,copy) NSString *sceneTitle;//主题title
@property (nonatomic,copy) NSString *des;//详细说明
@property (nonatomic,copy) NSString *sceneAboveImageURL;//
@property (nonatomic,copy) NSString *sceneGBImageURL;//
@property (nonatomic,retain) UIImage *sceneAboveImage;//上层图片
@property (nonatomic,retain) UIImage *sceneBGImage;//背景图片

@end
