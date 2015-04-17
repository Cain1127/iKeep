//
//  YSMMessageModel.h
//  iKeep
//
//  Created by ysmeng on 14/11/1.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSMvCardDataModel;
@interface YSMMessageModel : NSObject

@property (assign,nonatomic) XMPP_MESSAGE_TYPE type;//消息类型：是发出去的还是接收到的
@property (nonatomic,assign) XMPP_MESSAGE_READFLAG readStatu;//消息阅读状态
@property (copy,nonatomic) NSString *messageString;//文本消息
@property (copy,nonatomic) NSString *from;//来自于
@property (copy,nonatomic) NSString *fromName;//消息来源的名字
@property (copy,nonatomic) NSString *messageTime;//消息发送时间
@property (copy,nonatomic) NSString *to;//将要发送给
@property (nonatomic,retain) YSMvCardDataModel *vCard;//消息发送者的vCard信息

@end
