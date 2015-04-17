//
//  YSMMainHandleDataModel.h
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSMMainHandleDataModel : NSObject

@property (nonatomic,retain) id result;//返回的结果
@property (nonatomic,assign) BOOL resultFlag;//标记事件是否成功
@property (nonatomic,assign) NSTimeInterval AdvertTime;//广告显示时间
@property (nonatomic,assign) NSError *error;//错误信息

@end
