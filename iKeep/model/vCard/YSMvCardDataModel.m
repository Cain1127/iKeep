//
//  YSMvCardDataModel.m
//  iKeep
//
//  Created by ysmeng on 14/11/4.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMvCardDataModel.h"

@implementation YSMvCardDataModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.jidString = [aDecoder decodeObjectForKey:@"JIDString"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.domain = [aDecoder decodeObjectForKey:@"domain"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.shareAbout = [aDecoder decodeObjectForKey:@"shareAbout"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.weather = [aDecoder decodeObjectForKey:@"weather"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_jidString forKey:@"JIDString"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_domain forKey:@"domain"];
    [aCoder encodeObject:_nickName forKey:@"nickName"];
    [aCoder encodeObject:_icon forKey:@"icon"];
    [aCoder encodeObject:_shareAbout forKey:@"shareAbout"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_weather forKey:@"weather"];
}

@end
