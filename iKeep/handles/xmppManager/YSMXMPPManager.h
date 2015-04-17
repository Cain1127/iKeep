//
//  YSMXMPPManager.h
//  iKeep
//
//  Created by mac on 14-10-23.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSMXMPPFriendsInfoModel.h"
#import "YSMMessageModel.h"

@class YSMRegistUserDataModel;
@class XMPPvCardTempModule;
@class YSMLoginUserDataModel;
@class YSMvCardDataModel;
@interface YSMXMPPManager : NSObject

//*************************************************
//                  全局属性
//*************************************************
//全局名片模板
@property (nonatomic,strong) XMPPvCardTempModule *xmppvCardTempModel;

//*************************************************
//                  类方法
//*************************************************
//获取单例
+ (YSMXMPPManager *)shareXMPPManager;

//*************************************************
//                  对象方法
//*************************************************
#pragma mark - 连接服务器
//匿名连接服务器
- (BOOL)connectToServer:(NSString *)host andDomain:(NSString *)domain successCallBalk:(BLOCK_VOID_ACTION)successAction failCallBack:(BLOCK_ERROR_ACTION)failAction;
//退出
#pragma mark - 退出
- (void)disConnnectServer:(BOOL)flag;

#pragma mark - 注册用户
//注册用户
- (BOOL)registCount:(YSMRegistUserDataModel *)model successCallBack:(BLOCK_vCARDMODEL_ACTION)succAction failCallBack:(BLOCK_ERROR_ACTION)failAction;

#pragma mark - 登录
//注意: 登陆的时候同时连接, 异步操作
- (BOOL)loginWithModel:(YSMLoginUserDataModel *)model successCallBack:(BLOCK_VOID_ACTION)succAction failCallBack:(BLOCK_ERROR_ACTION)failAction;

#pragma mark - 获取好友列表
//获取好友列表
- (BOOL)getFriendsList:(BLOCK_ARRAY_ACTION)successAction andFailCallBack:(BLOCK_ERROR_ACTION)failAction;

#pragma mark - 添加好友
//添加好友
- (void)sendAddFriendRequestWithJidString:(NSString *)jidString andCallBack:(BLOCK_NSSTRING_ACTION)callBack;

#pragma mark - 消息接收与发送
//接收到消息的回调事件设置
- (void)monitorReciveMessage:(BLOCK_XMMODEL_ACTION)dealReciveFunc;
//接收消息条数提醒
- (void)monitorReceiveMessageTips:(BLOCK_INT_ACTION)callBack;
//读取消息
- (NSArray *)readMessage;
//发送消息
- (void)sendMessage:(NSString *)message toUsers:(NSArray *) familiesList;

#pragma mark - 添加监听添加好友的回调
- (void)registFriendRequestCallBack:(BLOCK_NSSTRING_BLOCK_ACTION)callBack;

#pragma mark - 更新头像
//更新头像
- (void)updatePersonHeaderIcon:(UIImage *)newIcon andCallBack:(BLOCK_vCARDMODEL_ACTION)callBack;

#pragma mark - 获取个人/好友vCard
- (BOOL)getSelfvCardMessage:(BLOCK_vCARDMODEL_ACTION)callBack;
- (BOOL)getFriendsvCardWithJID:(NSString *)jidString andCallBack:(BLOCK_vCARDMODEL_ACTION)callBack;

@end
