//
//  YSMRegistUserDataModel.h
//  iKeep
//
//  Created by ysmeng on 14/10/27.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSMRegistUserDataModel : NSObject

@property (nonatomic,copy) NSString *userID;//用户ID
@property (nonatomic,copy) NSString *userName;//登录用户名
@property (nonatomic,copy) NSString *nickName;//昵称
@property (nonatomic,copy) NSString *keyWord;//密码
@property (nonatomic,copy) NSString *email;//邮箱
@property (nonatomic,copy) UIImage *iconImage;//个人头像

@end
