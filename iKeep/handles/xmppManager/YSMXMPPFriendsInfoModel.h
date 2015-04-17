//
//  YSMXMPPFriendsInfoModel.h
//  iKeep
//
//  Created by ysmeng on 14/10/31.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSMvCardDataModel;
@interface YSMXMPPFriendsInfoModel : NSObject

@property (copy,nonatomic) NSString *jidString;
@property (copy,nonatomic) NSString *name;
@property (nonatomic,retain) YSMvCardDataModel *vCard;
@property (nonatomic,retain) NSData *vCardData;//模型数据流

@property (nonatomic,copy) NSString *userName;//用户名
@property (nonatomic,copy) NSString *domain;//服务器域
@property (nonatomic,copy) NSString *nickName;//昵称
@property (nonatomic,copy) UIImage *icon;//头像
@property (nonatomic,copy) NSString *shareAbout;//分享/说说
@property (nonatomic,copy) NSString *city;//当前城市
@property (nonatomic,copy) NSString *weather;//当前所在地方天气信息
@property (nonatomic,copy) NSString *lastLoginTime;//最后登录时间

@end
