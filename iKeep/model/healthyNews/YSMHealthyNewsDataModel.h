//
//  YSMHealthyNewsDataModel.h
//  iKeep
//
//  Created by ysmeng on 14/11/2.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSMHealthyNewsDataModel : NSObject <NSCoding>

@property (nonatomic,copy) NSString *newsID;//新联ID
@property (nonatomic,copy) NSArray *newsIDArray;//新闻ID数组
@property (nonatomic,assign) HEALTHY_NEWS_TYPE modelType;//新闻类型
@property (nonatomic,copy) NSURL *m3u8RUL;//保存视屏地址
@property (nonatomic,copy) UIImage *headerImage;//新闻头图片
@property (nonatomic,retain) NSArray *imagesArray;//图片数组
@property (nonatomic,copy) NSString *title;//新联标题
@property (nonatomic,copy) NSString *subTitle;//子标题
@property (nonatomic,copy) NSString *detail;//新闻详情
@property (nonatomic,copy) NSString *commentCount;//跟帖数
@property (nonatomic,copy) NSString *updateTime;//更新时间

@end
