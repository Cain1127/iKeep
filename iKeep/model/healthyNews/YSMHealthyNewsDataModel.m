//
//  YSMHealthyNewsDataModel.m
//  iKeep
//
//  Created by ysmeng on 14/11/2.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMHealthyNewsDataModel.h"

@implementation YSMHealthyNewsDataModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.newsID = [aDecoder valueForKey:@"newsID"];
        self.newsIDArray = [aDecoder valueForKey:@"newsIDArray"];
//        HEALTHY_NEWS_TYPE modelType;//新闻类型
        self.m3u8RUL = [aDecoder valueForKey:@"m3u8URL"];
        self.headerImage = [aDecoder valueForKey:@"headerImage"];
        self.imagesArray = [aDecoder valueForKey:@"imagesArray"];
        self.title = [aDecoder valueForKey:@"title"];
        self.subTitle = [aDecoder valueForKey:@"subTitle"];
        self.detail = [aDecoder valueForKey:@"detail"];
        self.commentCount = [aDecoder valueForKey:@"comment"];
        self.updateTime = [aDecoder valueForKey:@"updateTime"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.newsID forKey:@"newsID"];
    [aCoder encodeObject:self.newsIDArray forKey:@"newsIDArray"];
    [aCoder encodeObject:self.m3u8RUL forKey:@"m3u8URL"];
    [aCoder encodeObject:self.headerImage forKey:@"headerImage"];
    [aCoder encodeObject:self.imagesArray forKey:@"imagesArray"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.subTitle forKey:@"subTitle"];
    [aCoder encodeObject:self.detail forKey:@"detail"];
    [aCoder encodeObject:self.commentCount forKey:@"comment"];
    [aCoder encodeObject:self.updateTime forKey:@"updateTime"];
}

@end
